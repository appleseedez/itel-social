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
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    
    dispatch_queue_t asy= dispatch_queue_create("登陆", NULL);
    //异步线程执行
    dispatch_async(asy, ^{
        //登录接口
        if ([URLString isEqualToString:@"http://10.0.0.117:8080/CloudCommunity/login.json"]) {
            [self loginMockparameters:parameters constructingBodyWithBlock:block success:success failure:failure ];
        }

    });
    
    return nil;
}
//登录接口/login
static bool loginNetworkAvilable=YES; //mock网络是否可用
static float loginNetworkDelay=2.0; //mock网络延迟
static bool loginSuccess=YES;  //mock登陆是否成功
-(void)loginMockparameters:(NSDictionary *)parameters
 constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    //模拟网络不可用
    if (!loginNetworkAvilable) {
        NSError *error=[NSError errorWithDomain:@"网络不通" code:0 userInfo:nil];
        self.anything=error;
        //返回主线程回调哦
         dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(delay:) withObject:failure afterDelay:loginNetworkDelay];
         });
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
        //返回主线程回调
      dispatch_async(dispatch_get_main_queue(), ^{
          [self performSelector:@selector(delay:) withObject:success afterDelay:loginNetworkDelay];
      });
    }
}
-(void)delay: (void (^)(AFHTTPRequestOperation *operation, id responseObject))block {
    block(nil,self.anything);
    
}
@end
