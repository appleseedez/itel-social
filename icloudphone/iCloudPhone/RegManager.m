//
//  RegManager.m
//  iCloudPhone
//
//  Created by nsc on 13-12-10.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import "RegManager.h"
#import "NetRequester.h"
@implementation RegManager
static RegManager *manager;
+(RegManager*)defaultManager{
    if (manager==nil) {
        manager=[[RegManager alloc] init];
    }
    return manager;
}
-(void) checkNumberInterface{
       NSString *url=[NSString stringWithFormat:@"%@/register/registerSubmitByJson.json",SERVER_IP];
    NSDictionary *parameters=@{@"itelCode": self.regItel,@"type":self.regType,@"phone":self.regPhoneNumber,@"password":self.regPassword};
        [NetRequester jsonPostRequestWithUrl:url andParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSError *error=nil;
      responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        }
       // NSLog(@"%@",responseObject);
        NSDictionary *userInfo=@{@"success":@"1"};
       // NSString *msg=[responseObject objectForKey:@"msg"];
       // NSLog(@"%@",msg);
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECH_NUM_INTERFACE_NOTIFICATION object:responseObject userInfo:userInfo] ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *userInfo=@{@"success":@"0"};
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECH_NUM_INTERFACE_NOTIFICATION object:nil userInfo:userInfo] ;
    }];
}
-(void)sendMessageInterface{
    NSString *url=[NSString stringWithFormat:@"%@/register/checkPhoneByJson.json",SERVER_IP];
    NSDictionary *parameters=@{@"itelCode": self.regItel,@"phone":self.regPhoneNumber};
    [NetRequester jsonPostRequestWithUrl:url andParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSError *error=nil;
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        }
       // NSLog(@"%@",responseObject);
        //NSString *msg=[responseObject objectForKey:@"msg"];
        //NSLog(@"%@",msg);
        NSDictionary *userInfo=@{@"success":@"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECH_NUM_INTERFACE_NOTIFICATION object:responseObject userInfo:userInfo] ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *userInfo=@{@"success":@"0"};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECH_NUM_INTERFACE_NOTIFICATION object:nil userInfo:userInfo] ;
    }];
    
}
-(void)commitInterfaceCheckCode:(NSString*)CheckCode{
    NSString *url=[NSString stringWithFormat:@"%@/register/submitPhoneOkByJson.json",SERVER_IP];
    NSDictionary *parameters=@{@"itelCode": self.regItel,@"type":self.regType,@"phone":self.regPhoneNumber,@"password":self.regPassword,@"captcha":CheckCode};
    
    [NetRequester jsonPostRequestWithUrl:url andParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSError *error=nil;
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        }
        NSLog(@"%@",responseObject);
        NSString *msg=[responseObject objectForKey:@"msg"];
        NSLog(@"%@",msg);
        NSDictionary *userInfo=@{@"success":@"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:COMMIT_INTERFACE_NOTIFICATION object:responseObject userInfo:userInfo] ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *userInfo=@{@"success":@"0"};
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:COMMIT_INTERFACE_NOTIFICATION object:nil userInfo:userInfo] ;
    }];

}
@end
