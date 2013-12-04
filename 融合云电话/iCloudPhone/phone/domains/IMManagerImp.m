//
//  IMManagerImp.m
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMManagerImp.h"
#import  "ConstantHeader.h"
@interface IMManagerImp ()

//状态标识符，表明当前所处的状态。目前只有占用和空闲两种 占用：IN_USE，空闲：IDLE
@property (nonatomic,copy) NSString* state;
@property (nonatomic,copy) NSString* selfAccount;
@property (nonatomic,strong) NSTimer* keepSessionAlive;//从获取到外网地址，到收到通话回复。
@end

@implementation IMManagerImp
#pragma mark - LOGIC

- (void) testSessionStart:(NSString*) destAccount{
    // 通话查询开始
    [self startSession:destAccount];
    // 构造通话查询信令
    self.messageBuilder = [[IMSessionInitMessageBuilder alloc] init];
    //通话查询请求数据的构造
    NSDictionary* data = [self.messageBuilder buildWithParams:@{SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY: destAccount}];
    // 发送信令数据到信令服务器
    [self.communicator send:data];
    // 转到 [self receive:];
}
// 向信令服务器做一次验证
- (void) auth:(NSString*) selfAccount
         cert:(NSString*) cert{
    NSString* token = @""; // 推送用到的token
    self.messageBuilder = [[IMAuthMessageBuilder alloc] init];
    NSDictionary* data = [self.messageBuilder buildWithParams:@{
                                                                CMID_APP_LOGIN_SSS_REQ_FIELD_ACCOUNT_KEY:selfAccount,
                                                                CMID_APP_LOGIN_SSS_REQ_FIELD_CERT_KEY:cert,
                                                                CMID_APP_LOGIN_SSS_REQ_FIELD_TOKEN_KEY:token
                                                                }];
    [self.communicator send:data];
}

#pragma mark - PRIVATE

// 注册通知
- (void)registerNotifications {
    //网络通信器会在收到数据响应时，发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:DATA_RECEIVED_NOTIFICATION object:nil];
    //对收到的信令响应数据进行解析后，如果是通话查询请求的响应，则发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInited:) name:SESSION_INITED_NOTIFICATION object:nil];
    //通话请求期间的数据通信，都发这个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionPeriod:) name:SESSION_PERIOD_NOTIFICATION object:nil];
    //通话终止，发这个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionHalt:) name:SESSION_PERIOD_HALT_NOTIFICATION object:nil];
    //登录到信令服务器后，需要做一次验证，验证信息响应时，发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authHasResult:) name:CMID_APP_LOGIN_SSS_NOTIFICATION object:nil];
}

//移除通知 防止leak
- (void) removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 依赖注入
- (void)injectDependency {
    self.engine = [[IMEngineImp alloc] init];// 引擎
    self.communicator = [[IMTCPCommunicator alloc] init];// 网络通信器
    self.messageParser = [[IMMessageParserImp alloc] init]; // 信令解析器
    
}
//根据数据的具体类型做操作路由
- (void) route:(NSDictionary*) data{
    NSInteger type = -1;
    //具体的数据
    NSDictionary* bodySection = @{};
    // 以是否具有head块作为解析依据。
    
    // 获取头部数据
    NSDictionary* headSection = [data valueForKey:HEAD_SECTION_KEY];
    if (headSection) {
        type = [[headSection valueForKey:DATA_TYPE_KEY] integerValue];
        NSInteger status = [[headSection valueForKey:DATA_STATUS_KEY] integerValue];
        // 异常情况处理。
        if (status != NORMAL_STATUS) {
            [NSException exceptionWithName:@"500:data format error" reason:@"信令服务器返回数据状态不正常" userInfo:nil];
            return;
        }
        bodySection = [data valueForKey:BODY_SECTION_KEY];
    }else{
        type = [[data valueForKey:DATA_TYPE_KEY] integerValue];
        bodySection = data;
    }
    
    //路由
    switch (type) {
        case SESSION_INIT_RES_TYPE:
            // 通话查询请求正常返回，通知业务层
            // [self sessionInited:]
            [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_INITED_NOTIFICATION object:nil userInfo:bodySection];
            break;
        case SESSION_PERIOD_PROCEED_TYPE:
            [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_PERIOD_NOTIFICATION object:nil userInfo:bodySection];
            break;
        case CMID_APP_LOGIN_SSS_RESP_TYPE: //信令服务器验证响应返回了，通知业务层
            [[NSNotificationCenter defaultCenter] postNotificationName:CMID_APP_LOGIN_SSS_NOTIFICATION object:nil userInfo:bodySection];
            break;
        case SESSION_PERIOD_HALT_TYPE:
            [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_PERIOD_HALT_NOTIFICATION object:nil userInfo:bodySection];
            break;
        default:
            break;
    }
    
}
/**
 *  通话建立过程中的协议交换
 *
 *  封装了构造和发送通话请求和回复的过程。
 *  用过使用不同的信令构造器，就可以做到用一套逻辑处理请求和回复两种
 *
 *  @param void negotiationData 协议数据
 *
 *  @return void
 */
- (void) sessionPeriodNegotiation:(NSDictionary*) negotiationData{
    NSDictionary* parsedData =  [self.messageParser parse:negotiationData];
#if MANAGER_DEBUG
    NSLog(@"获取到的谈判数据：%@",parsedData);
#endif
    NSString* forwardIP = [parsedData valueForKey:SESSION_INIT_RES_FIELD_FORWARD_IP_KEY];
    NSInteger forwardPort = [[parsedData valueForKey:SESSION_INIT_RES_FIELD_FORWARD_PORT_KEY] integerValue];
    // 获取本机natType
    NatType natType = [self.engine natType];
    // 获取本机的链路列表. 中继服务器目前充当外网地址探测
    NSDictionary* communicationAddress = [self.engine endPointAddressWithProbeServer:forwardIP port:forwardPort];
    [self.keepSessionAlive invalidate];
// 获取到外网地址后，开始发送数据包到外网地址探测服务器，直到收到对等方的回复。
    NSLog(@"开始进行保持外网session的数据包发送");
    self.keepSessionAlive = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(keepSession:) userInfo:@{PROBE_PORT_KEY:[NSNumber numberWithInteger:forwardPort],PROBE_SERVER_KEY:forwardIP} repeats:YES];
    //此处我需要做的是字典的数据融合！！！
    NSMutableDictionary* mergeData = [communicationAddress mutableCopy];
    //将信令服务器返回的通话查询请求的响应中的转发地址和目的号码取出来，合并进新的通话请求信令中
    [mergeData addEntriesFromDictionary:@{
                                          DATA_TYPE_KEY:[NSNumber numberWithInteger:SESSION_PERIOD_PROCEED_TYPE],
                                          SESSION_INIT_RES_FIELD_FORWARD_IP_KEY:
                                              [parsedData valueForKey:SESSION_INIT_RES_FIELD_FORWARD_IP_KEY],
                                          SESSION_INIT_RES_FIELD_FORWARD_PORT_KEY:
                                              [parsedData valueForKey:SESSION_INIT_RES_FIELD_FORWARD_PORT_KEY],
                                          SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY: self.selfAccount,
                                          SESSION_SRC_SSID_KEY:[parsedData valueForKey:SESSION_DEST_SSID_KEY], //总是在传递是以接收方的角度去思考
                                          SESSION_DEST_SSID_KEY:[parsedData valueForKey:SESSION_SRC_SSID_KEY]
                                          }];
    //由于信令是发给对方的。所以destAccount和srcaccount应该是从对方的角度去思考。因此destAccount填的是自己的帐号，srcaccount填写的是对方的帐号。这样，在对方看来就是完美的。而且，对等方在构造信令数据时有相同的逻辑
    [mergeData addEntriesFromDictionary:@{SESSION_INIT_REQ_FIELD_SRC_ACCOUNT_KEY:[parsedData valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY]}];
    // 通话请求信令中，需要本机的NAT类型。
    [mergeData addEntriesFromDictionary:@{SESSION_PERIOD_FIELD_PEER_NAT_TYPE_KEY: [NSNumber numberWithInt:natType]}];
    // 构造通话数据请求
    NSDictionary* data = [self.messageBuilder buildWithParams:mergeData];
    [self.communicator send:data];
}


- (void) keepSession:(NSTimer*) timer{
    NSLog(@"开始发送保持session的数据包");
    NSDictionary* param = [timer userInfo];
    NSString* probeServerIP = [param valueForKey:PROBE_SERVER_KEY];
    NSInteger port = [[param valueForKey:PROBE_PORT_KEY] integerValue];
    [self.engine keepSessionAlive:probeServerIP port:port];
}
/**
 *  收到终止信令的回复
 *
 *  @param notify 拒绝数据
 */
- (void) sessionHalt:(NSNotification*) notify{
#if MANAGER_DEBUG
    NSLog(@"收到拒绝信令回复");
#endif
    NSString* haltType = [notify.userInfo valueForKey:SESSION_HALT_FIELD_TYPE_KEY];
    if ([SESSION_HALT_FILED_ACTION_BUSY isEqualToString:haltType]) {
        [self endSession];
    }else if ([SESSION_HALT_FILED_ACTION_REFUSE isEqualToString:haltType]){
        [self endSession];
    }else if ([SESSION_HALT_FILED_ACTION_END isEqualToString:haltType]){
        [self.engine stopTransport];
        [self endSession];
    }else{
        //
    }
    //通知界面，关闭相应的视图
    [[NSNotificationCenter defaultCenter] postNotificationName:END_SESSION_NOTIFICATION object:nil userInfo:nil];
}

/**
 *  通话拒绝
 *  只是做信令数据的构造和发送
 */

-(void) sessionHaltRequest:(NSDictionary*) refuseData{
#if MANAGER_DEBUG
    NSLog(@"发送拒绝信令");
#endif
    // 处理参数
    NSDictionary* params = @{
                             DATA_TYPE_KEY:[NSNumber numberWithInteger:SESSION_PERIOD_HALT_TYPE],
                             SESSION_INIT_REQ_FIELD_SRC_ACCOUNT_KEY:[refuseData valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY],
                             SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY:[refuseData valueForKey:SESSION_INIT_REQ_FIELD_SRC_ACCOUNT_KEY],
                             SESSION_HALT_FIELD_TYPE_KEY:[refuseData valueForKey:SESSION_HALT_FIELD_TYPE_KEY]
                             };
    NSLog(@"准备发送的终止信令：%@",params);
    self.messageBuilder = [[IMSessionRefuseMessageBuilder alloc] init];
    NSDictionary* data =  [self.messageBuilder buildWithParams:params];
    [self.communicator send:data];
}

#pragma mark - NOTIFICATION HANDLE

// 信令回复数据的处理 采用通知来完成
- (void) receive:(NSNotification*) notify{
#if MANAGER_DEBUG
    NSLog(@"收到数据，路由给处理逻辑");
#endif
    [self route:notify.userInfo];
}

//收到信令服务器的通话查询响应，进行后续业务
- (void) sessionInited:(NSNotification*) notify{
#if MANAGER_DEBUG
    NSLog(@"收到通话查询响应~");
#endif
    NSMutableDictionary *data = [notify.userInfo mutableCopy];
    [data addEntriesFromDictionary:@{
                                    SESSION_SRC_SSID_KEY:[notify.userInfo valueForKey:SESSION_INIT_RES_FIELD_SSID_KEY],
                                    SESSION_DEST_SSID_KEY:[NSNumber numberWithInteger:[[notify.userInfo valueForKey:SESSION_INIT_RES_FIELD_SSID_KEY] integerValue]+1]}];
    self.messageBuilder = [[IMSessionPeriodRequestMessageBuilder alloc] init];
    [self sessionPeriodNegotiation:data];
    // TODO 设置10秒超时，如果没有收到接受通话的回复则转到拒绝流程
    
}

//收到peer端的请求类型，则首先检查自己是否是被占用状态。
//在非占用状态下，10秒内用户主动操作接听，则开始构造响应类型数据，同时本机设置为占用状态，然后开始获取p2p的后续操作
- (void) sessionPeriod:(NSNotification*) notify{
    NSString* currentDest = [notify.userInfo valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY];
    if ([self.state isEqualToString:currentDest]) { //如果收到的通话信令就是自己正在拨打的。则表明自己是拨打方，可以开始p2p流程了
        //开始获取p2p通道，保持session的数据包可以停止发送了。
#if MANAGER_DEBUG
        NSLog(@"收到响应，开始通话");
#endif
        [self.keepSessionAlive invalidate];
        self.keepSessionAlive = nil;
    NSLog(@"开始通话，停止session保持数据包的发送，开始获取p2p通道");
        
        NSLog(@"收到PEER的链路数据：%@",notify.userInfo);
        if (![self.engine tunnelWith:notify.userInfo]) {
            [NSException exceptionWithName:@"p2p穿透失败" reason:@"p2p穿透失败" userInfo:nil];
            return;
        }
        
        [self.engine startTransport];
        //通知view可以切换的到“通话中"界面了
        [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_INSESSION_VIEW_NOTIFICATION
                                                            object:nil
                                                          userInfo:notify.userInfo];
    }else if ([self.state isEqualToString:IDLE]){ //如果是idle状态下，接到了通话信令，则是有人拨打
#if MANAGER_DEBUG
        NSLog(@"收到通话请求，用户操作可以接听");
#endif
        //通知界面，弹出通话接听界面:[self sessionPeriodResponse:notify]
        [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_PERIOD_REQ_NOTIFICATION object:nil userInfo:notify.userInfo];
    }else{//剩余的情况表明。当前正在通话中，应该拒绝 这里会是自动拒绝 
        // Todo 构造拒绝信令
        NSLog(@"当前的对方号码为：%@",currentDest);
        NSDictionary* busyData = @{
                                     DATA_TYPE_KEY:[NSNumber numberWithInteger:SESSION_PERIOD_HALT_TYPE],
                                     SESSION_INIT_REQ_FIELD_SRC_ACCOUNT_KEY:currentDest,
                                     SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY:self.state,
                                     SESSION_HALT_FIELD_TYPE_KEY:SESSION_HALT_FILED_ACTION_BUSY
                                     };
        [self sessionHaltRequest:busyData];
    }
}
//如果是处理的peer端的响应类型。那么，有可能是接受通话，则接下来开始进行p2p通道获取; 也有可能是拒绝通话，则通话请求终止
- (void) sessionPeriodResponse:(NSNotification*) notify{
    //首先，开启会话，设置处于占线状态
    [self startSession:[notify.userInfo valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY]];
    //既然是接受通话，则信令构造器要换成回复的类型
    self.messageBuilder = [[IMSessionPeriodResponseMessageBuilder alloc] init];
    // 把自身的链路信息作为响应发出，表明本机接受通话请求
    [self sessionPeriodNegotiation:notify.userInfo];
    // 开始获取p2p通道
    [self.keepSessionAlive invalidate];
    self.keepSessionAlive = nil;
    NSLog(@"接受通话请求，停止session保持数据包的发送，开始获取p2p通道");
    if (![self.engine tunnelWith:notify.userInfo]) {
        [NSException exceptionWithName:@"p2p穿透失败" reason:@"p2p穿透失败" userInfo:nil];
        return;
    }
    
    [self.engine startTransport];
}

//收到信令服务器的验证响应，
- (void) authHasResult:(NSNotification*) notify{
#if MANAGER_DEBUG
    NSLog(@"收到信令服务器端帐号验证响应~");
#endif
}

#pragma mark - INTERFACE

// IMManager 接口的实现
- (void)setup{
    [self injectDependency];
    //环境初始化
    [self.engine initNetwork];
    [self.engine initMedia];
    [self endSession];
    /*测试需要，自动生成随机号码*/
    self.selfAccount = [NSString stringWithFormat:@"%d",arc4random()%1000];
}

- (void)connectToSignalServer{
#if MANAGER_DEBUG
    NSLog(@"开始连接信令服务器");
#endif
    //注册事件
    [self registerNotifications];
    //连接信令服务器
    [self.communicator connect];
    [self.communicator keepAlive];
    
//    NSString *urlAsString = @"http://192.168.1.106:2000";
//    NSURL *url = [NSURL URLWithString:urlAsString];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        //
//        if ([data length]) {
//            NSDictionary* accountJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            NSString* randomAccount = [accountJSON valueForKey:@"number"];
//            self.selfAccount = randomAccount;
//            NSLog(@"获取到的随机帐号：%@",randomAccount);
//        }
//
//    }];
    
    //向信令服务器发验证请求
    if (!self.selfAccount) {
        self.selfAccount = @"6666";
    }
    NSLog(@"目前的本机帐号：%@",[self myAccount]);
    [self auth:self.selfAccount cert:@"chengjianjun"];
    
}
- (void)disconnectToSignalServer{
    [self.communicator disconnect];
    [self removeNotifications];
}
- (void) tearDown{
#if MANAGER_DEBUG
    NSLog(@"call tearDown");
#endif
    [self disconnectToSignalServer];
    [self.engine tearDown];
    self.engine=nil;
    self.communicator =  nil;
    self.messageBuilder = nil;
}
- (void)startSession:(NSString*) destAccount{
    self.state = destAccount;
}
- (void)endSession{
    self.state = IDLE;
}

- (void)dial:(NSString *)account{
    [self testSessionStart:account];
}
// 用户点击时，将通知数据传入
- (void) acceptSession:(NSNotification*) notify{
    [self sessionPeriodResponse:notify];
}
// 终止当前的通话
- (void)haltSession:(NSDictionary*) data{
    [self.engine stopTransport];
    [self sessionHaltRequest:data];
    [self endSession];
    //通知界面，关闭相应的视图
    [[NSNotificationCenter defaultCenter] postNotificationName:END_SESSION_NOTIFICATION object:nil userInfo:nil];
}

- (void)openScreen:(VideoRenderIosView *)remoteRenderView{
    [self.engine openScreen:remoteRenderView];
}
- (void)closeScreen{
}
- (void)lockScreenForSession{
    [UIApplication sharedApplication].idleTimerDisabled=YES;
}

- (void)unlockScreenForSession{
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}
- (NSString *)myAccount{
    return self.selfAccount;
}
@end
