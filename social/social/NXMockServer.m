//
//  NXMockServer.m
//  social
//
//  Created by nsc on 13-11-8.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "NXMockServer.h"

@interface NXMockServer ()
@property (nonatomic,strong) id anything;
@end

static NXMockServer *server;
@implementation NXMockServer

+(NXMockServer*)sharedServer{
    if (server==nil) {
        server = [[NXMockServer alloc] init];
    }
    return server;
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    //登录接口
    if ([URLString isEqualToString:@"/login"]) {
        [self loginMockparameters:parameters success:success failure:failure];
    }
    
    return nil;
}
//登录接口/login
static bool loginNetworkAvilable=YES;
static float loginNetworkDelay=2.0;
static bool loginSuccess=YES;
-(void)loginMockparameters:(NSDictionary *)parameters
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    //模拟网络不可用
    if (!loginNetworkAvilable) {
        NSError *error=[NSError errorWithDomain:@"网络不通" code:0 userInfo:nil];
        self.anything=error;
        [self performSelector:@selector(delay:) withObject:failure afterDelay:loginNetworkDelay];
  
    }
    //模拟网络可用返回数据
    else {
        NSMutableDictionary *returnParameter=[[NSMutableDictionary alloc]init];
        if (loginSuccess) {
            NSMutableDictionary *returnData=[[NSMutableDictionary alloc]init];
            [returnData setValue:@"0" forKey:@"user_id"];
            [returnData setValue:@"10086" forKey:@"itel"];
            [returnData setValue:@"流浪的猫" forKey:@"nick_name"];
            [returnData setValue:@"http://www.baidu.com" forKey:@"photo"];
            [returnData setValue:@"efdikfsauwd122jai2jjaa2412451241" forKey:@"token"];
            [returnData setValue:@"0" forKey:@"user_type"];
            [returnData setValue:@"http://192.168.0.12" forKey:@"domain"];
            [returnData setValue:@"8080" forKey:@"port"];
            
            
            [returnParameter setValue:@"0" forKey:@"ret"];
            [returnParameter setValue:@"200" forKey:@"code"];
            [returnParameter setValue:@"msg" forKey:@"登录成功"];
            [returnParameter setValue:returnData forKey:@"data"];
            
        }
        else{
           
            
            [returnParameter setValue:@"1" forKey:@"ret"];
            [returnParameter setValue:@"400" forKey:@"code"];
            [returnParameter setValue:@"用户名不存在" forKey:@"msg"];
            [returnParameter setValue:@"-1" forKey:@"data"];
        }
        self.anything=returnParameter;
        [self performSelector:@selector(delay:) withObject:success afterDelay:loginNetworkDelay];
       
    }
    
}
-(void)delay: (void (^)(NSURLSessionDataTask *task, id responseObject))block {
    block(nil,self.anything);
    
}
@end
