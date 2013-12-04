//
//  IMEngineImp.m
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMEngineImp.h"
#import "AVInterface.h"
#import "NatTypeImpl.h"
#import "ConstantHeader.h"
#import "video_render_ios_view.h"
UIImageView* _pview_local;

@interface IMEngineImp ()
@property(nonatomic) CAVInterfaceAPI* pInterfaceApi;
@property(nonatomic) InitType m_type;
@property(nonatomic,copy) NSString* currentInterIP;
@end

@implementation IMEngineImp
- (id)init{
    if (self = [super init]) {
        if (_pInterfaceApi == nil) {
            _pInterfaceApi = new CAVInterfaceAPI();
        }
    }
    return self;
}

+ (NSString*) localAddress{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    
    NSLog(@">>>>>>>>>本机ip地址: %@",addr);
    return addr;
}

-(NSInteger) getCameraOrientation:(NSInteger) cameraOrientation
{
    UIInterfaceOrientation displatyRotation = [[UIApplication sharedApplication] statusBarOrientation];
    NSInteger degrees = 0;
    switch (displatyRotation) {
        case UIInterfaceOrientationPortrait: degrees = 0; break;
        case UIInterfaceOrientationLandscapeLeft: degrees = 90; break;
        case UIInterfaceOrientationPortraitUpsideDown: degrees = 180; break;
        case UIInterfaceOrientationLandscapeRight: degrees = 270; break;
    }
    
    NSInteger result = 0;
    if (cameraOrientation > 180) {
        result = (cameraOrientation + degrees) % 360;
    } else {
        result = (cameraOrientation - degrees + 360) % 360;
    }
    
    return result;
}


#pragma mark - INTERFACE

// IMEngine接口 见接口定义
- (void)initNetwork{
    if (false == self.pInterfaceApi->NetWorkInit(LOCAL_PORT)) {
        [NSException exceptionWithName:@"400: init network failed" reason:@"引擎初始化网络失败" userInfo:nil];
    }
}

- (void)initMedia{
    self.m_type = self.pInterfaceApi->MediaInit(SCREEN_WIDTH,SCREEN_HEIGHT,InitTypeNone);
    NSLog(@"媒体类型：%d",self.m_type);
}

- (NatType)natType{
    NatTypeImpl nat;
    return nat.GetNatType("stunserver.org");
}

- (NSDictionary*)endPointAddressWithProbeServer:(NSString*) probeServerIP port:(NSInteger) probeServerPort{
    NSLog(@"外网地址探测服务器地址：%@",probeServerIP);
    char self_inter_ip[16];
    uint16_t self_inter_port;
    //获取本机外网ip和端口
    int ret = self.pInterfaceApi->GetSelfInterAddr([probeServerIP UTF8String], probeServerPort, self_inter_ip, self_inter_port);
    if (ret != 0) {
        self.currentInterIP = @"";
    }else{
        self.currentInterIP =[NSString stringWithUTF8String:self_inter_ip];
    }
    return @{
            SESSION_PERIOD_FIELD_PEER_INTER_IP_KEY: self.currentInterIP,
             SESSION_PERIOD_FIELD_PEER_INTER_PORT_KEY:[NSNumber numberWithInt:self_inter_port],
             SESSION_PERIOD_FIELD_PEER_LOCAL_IP_KEY:[[self class] localAddress],
             SESSION_PERIOD_FIELD_PEER_LOCAL_PORT_KEY:[NSNumber numberWithInt:LOCAL_PORT]
             };
}

- (int)tunnelWith:(NSDictionary*) params{
    NSLog(@"开始获取p2p通道");
     TP2PPeerArgc argc;
    
    
    // 外网地址
    ::strncpy(argc.otherInterIP, [[params valueForKey:SESSION_PERIOD_FIELD_PEER_INTER_IP_KEY] UTF8String], sizeof(argc.otherInterIP));
    argc.otherInterPort = [[params valueForKey:SESSION_PERIOD_FIELD_PEER_INTER_PORT_KEY] intValue];
    // 内网地址
    ::strncpy(argc.otherLocalIP, [[params valueForKey:SESSION_PERIOD_FIELD_PEER_LOCAL_IP_KEY] UTF8String], sizeof(argc.otherLocalIP));
    argc.otherLocalPort =  [[params valueForKey:SESSION_PERIOD_FIELD_PEER_LOCAL_PORT_KEY] intValue];
    // 转发地址
    ::strncpy(argc.otherForwardIP,[[params valueForKey:SESSION_INIT_RES_FIELD_FORWARD_IP_KEY] UTF8String], sizeof(argc.otherForwardIP));
    argc.otherForwardPort = [[params valueForKey:SESSION_INIT_RES_FIELD_FORWARD_PORT_KEY] intValue];
    
    // 对方的ssid
    argc.otherSsid = [[params valueForKey:SESSION_DEST_SSID_KEY] intValue];
    // 自己的ssid
    argc.selfSsid = [[params valueForKey:SESSION_SRC_SSID_KEY] intValue];
    
    //如果内网的ip相同.设置argc.localable = true;
    
    NSLog(@"本机的外网ip：%@",self.currentInterIP);
    NSLog(@"对方的外网ip：%@",[NSString stringWithUTF8String:argc.otherInterIP]);
    if ([self.currentInterIP isEqualToString:[NSString stringWithUTF8String:argc.otherInterIP]]) {
        argc.localEnble = true;
    }else{
        argc.localEnble = false;
    }
    NSLog(@"设置localable为：%d",argc.localEnble);
    NSLog(@"通话参数：对方外网ip：%s",argc.otherInterIP);
    NSLog(@"通话参数：对方外网port：%i",argc.otherInterPort);
    NSLog(@"通话参数：对方内网ip：%s",argc.otherLocalIP);
    NSLog(@"通话参数：对方内网port:%i",argc.otherLocalPort);
    NSLog(@"通话参数：对方ssid：%i",argc.otherSsid);
    NSLog(@"通话参数：自己ssid：%i",argc.selfSsid);
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    if (self.pInterfaceApi->GetP2PPeer(argc) != 0) {
        return -1;
    }
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    long long  dTime =endTime - startTime;
    NSLog(@"调用时间间隔：%@",[NSString stringWithFormat:@"%llu",dTime]);
    bool ret;
    NSLog(@"isLocal的状态：%d",argc.islocal);
    if (argc.islocal)
    {
        NSLog(@"内网可用[%s:%d]", argc.otherLocalIP, argc.otherLocalPort);
        ret = self.pInterfaceApi->StartMedia(self.m_type, argc.otherLocalIP, argc.otherLocalPort);// 要判断返回值
    }
    else if (argc.isInter)
    {
        NSLog(@"外网可用[%s:%d]", argc.otherInterIP, argc.otherInterPort);
        ret = self.pInterfaceApi->StartMedia(self.m_type, argc.otherInterIP, argc.otherInterPort);// 要判断返回值
    }
    else
    {
        NSLog(@"转发可用[%s:%d]", argc.otherForwardIP, argc.otherForwardPort);
        ret = self.pInterfaceApi->StartMedia(InitTypeVoe, argc.otherForwardIP, argc.otherForwardPort);// 要判断返回值
    }
    if (!ret)
    {
        NSLog(@"传输初期化失败");
    }
    
    
    return ret;
}
- (BOOL)startTransport{
    
    
    return NO;
}

- (void)stopTransport{
    bool ret = self.pInterfaceApi->StopMedia(self.m_type);
    NSLog(@"关闭传输通道成功：%d",ret);
    //通知界面
//    [[NSNotificationCenter defaultCenter] postNotificationName:END_SESSION_NOTIFICATION object:nil userInfo:nil];
}
- (void)openScreen:(VideoRenderIosView*) remoteRenderView{
    // 开启摄像头
    if (self.pInterfaceApi->StartCamera(1) >= 0)
    {
        // 摆正摄像头位置
        self.pInterfaceApi->VieSetRotation([self getCameraOrientation:self.pInterfaceApi->VieGetCameraOrientation(0)]);
    }
    self.pInterfaceApi->VieAddRemoteRenderer((__bridge void*)remoteRenderView);
}
- (void)closeScreen{
}

- (void)tearDown{
    self.pInterfaceApi->Terminate();
}

- (void)keepSessionAlive:(NSString*) probeServerIP port:(NSInteger)port{
    u_int8_t tick = 0xFF;
    self.pInterfaceApi->SendUserData(&tick, sizeof(u_int8_t), [probeServerIP UTF8String], port);
}
@end
