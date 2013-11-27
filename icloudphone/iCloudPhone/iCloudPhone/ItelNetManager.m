    //
//  ItelNetManager.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ItelNetManager.h"
#import "AFNetworking.h"
#import "ItelAction.h"
#import "NXInputChecker.h"
#import "HostItelUser.h"
#define  SUCCESS void (^success)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
#define  FAILURE void (^failure)(AFHTTPRequestOperation *operation, NSError *error)   = ^(AFHTTPRequestOperation *operation, NSError *error)
static NSString *server=@"http://10.0.0.40:8080/CloudCommunity";
static ItelNetManager *manager=nil;
@implementation ItelNetManager

+(ItelNetManager*)defaultManager{
    
    if (manager==nil) {
        manager=[[ItelNetManager alloc]init];
    }
   
    return manager;
}
#pragma mark -通用请求
-(void)jsonPostRequestWithUrl:(NSString*)url
                         andParameters:(NSDictionary*)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSData *httpBody=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:httpBody];
     AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [operation start];
    
}
-(void)jsonGetRequestWithUrl:(NSString*)url
                andParameters:(NSDictionary*)parameters
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableURLRequest *request=[[AFJSONRequestSerializer serializer] requestWithMethod:@"get" URLString:url parameters:parameters];
   
    //[request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //NSData *httpBody=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    // [request setHTTPBody:httpBody];
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [operation start];
    
}


#pragma mark - 添加联系人
//http://10.0.0.40:8080/CloudCommunity/contact/addItelFriend.json
-(void)addUser:(NSDictionary*)parameters{
    
    NSString *url=[NSString stringWithFormat:@"%@/contact/addItelFriend.json",server];
    SUCCESS{
        id json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([json isKindOfClass:[NSDictionary class]]) {
            //NSLog(@"%@",json);
            NSDictionary *dic=(NSDictionary*)json;
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
                [[ItelAction action] inviteItelUserFriendResponse];
               }
            else {
                NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":[dic objectForKey:@"msg"] };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"inviteItelUser" object:nil userInfo:userInfo];
            }
            }
    };
    FAILURE{
         NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"网络异常" };
          [[NSNotificationCenter defaultCenter] postNotificationName:@"inviteItelUser" object:nil userInfo:userInfo];
        };
    [self jsonPostRequestWithUrl:url andParameters:parameters success:success failure:failure];
}
#pragma mark - 删除联系人

-(void)delUser:(NSDictionary*)parameters{
  
      NSString *url=[NSString stringWithFormat:@"%@/contact/removeItelFriend.json",server];
    SUCCESS{
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSString *itel=[parameters objectForKey:@"targetItel"];
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
                [[ItelAction action] delFriendFromItelBookResponse:itel];
            }
            else {
                NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"解析异常" };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"delItelUser" object:nil userInfo:userInfo];
            }
        }
    };
    FAILURE{
        NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"网络异常" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delItelUser" object:nil userInfo:userInfo];
        NSLog(@"%@",error);
    };
    [self jsonPostRequestWithUrl:url andParameters:parameters success:success failure:failure];

}
#pragma mark - 查找用户接口

-(void)searchUser:(NSString*)search isNewSearch:(BOOL)isNewSearch{
    static  int start=0;
    static  int limit=20;
    if (isNewSearch) {
        start=0;
    }
    else{
        start=start+limit;
    }
    
    NSString *url=[NSString stringWithFormat:@"%@/contact/searchUser.json",server];
    //post参数
    NSDictionary *Parameters=@{@"start":[NSNumber numberWithInt:start],
                               @"limit":[NSNumber numberWithInt:limit],
                               @"keyWord":search,
                               @"token":@"2JSD1I2K4J1K234J41" };
    NSLog(@"keyword:%@",[Parameters objectForKey:@"keywords"]);
        SUCCESS{
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]]) {
                    int ret=[[dic objectForKey:@"ret"] intValue];
                if (ret==0) {
                    BOOL isEnd=0;
                    int rtotal=[[dic objectForKey:@"total"] intValue];
                    int rstart=[[dic objectForKey:@"start"] intValue];
                    int rlimit=[[dic objectForKey: @"limit"] intValue];
                    if (rtotal>rstart+rlimit) {
                        isEnd=0;
                    }
                    else {
                        isEnd=1;
                    }
                    
                    id data =[dic objectForKey:@"data"];
                    [[ItelAction action] searchStrangerResponse:data isEnd:isEnd];
                    }
            else {
                NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":[dic objectForKey:@"msg"] };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"searchStranger" object:nil userInfo:userInfo];
               }
        }//如果请求失败 则执行failure
    };
    FAILURE {
        NSLog(@"%@",error);
        NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"网络异常" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchStranger" object:nil userInfo:userInfo];
        };
    [self jsonGetRequestWithUrl:url andParameters:Parameters success:success failure:failure];
}
#pragma mark - 拨打用户电话接口
/*
   待完善
 */
-(void)callUserWithItel:(NSString *)itelNum{
    
}
#pragma mark - 访问用户商店接口
/*
 待完善
 */
-(void)visitUserStore:(NSString *)itelNum{
    
}

#pragma mark - 匹配通讯录中得联系人
/*匹配通讯录中得联系人接口
   1 获得本机所有联系人电话
   2 网络请求
*/
-(void)checkAddressBookForItelUser:(NSArray*)phones{
    
    NSString *url=[NSString stringWithFormat:@"%@/contact/matchLocalContactsUser.json",server];
    HostItelUser *host=[[ItelAction action] getHost];
    NSNumber *number=[NSNumber numberWithInteger:[host.userId intValue] ];
    NSString *strPhones=[NXInputChecker changeArrayToString:phones];
    strPhones =[NSString stringWithFormat:@"%@,15799990000,15899990000,15899990001,15699990000,15399990000,15899990022",strPhones];
    
    NSDictionary *parameters=@{@"hostUserId":number, @"numbers":strPhones,@"token":@"123456"};
    NSLog(@"%@",parameters);
     SUCCESS {
            //NSLog(@"%@",responseObject);
         dispatch_queue_t getPhones=dispatch_queue_create("getPhones", NULL);
         dispatch_async(getPhones, ^{
       
         id dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:Nil];
         NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]]) {
                
                int ret=[[dic objectForKey:@"ret"] intValue];
                if (ret==0) {
                    NSArray *itelusers=[dic objectForKey:@"data"];
                    if ([itelusers count]) {
                        ItelAction *action = [ItelAction action];
                        [action checkAddressBookMatchingResponse:itelusers];
                    }
                }
            else {
                NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":[dic objectForKey:@"msg"] };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"checkAddress" object:nil userInfo:userInfo];
                }
        }  });//如果请求失败 则执行failure
    };
    FAILURE{
        NSLog(@"%@",error);
        NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"网络异常" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkAddress" object:nil userInfo:userInfo];
      };
    [self jsonGetRequestWithUrl:url andParameters:parameters success:success failure:failure];
}
#pragma mark - 添加号码到黑名单
-(void)addToBlackList:(NSDictionary*)parameters;{
   
    NSString *url=[NSString stringWithFormat:@"%@/contact/addBlack.json",server];
    SUCCESS{
        
        NSError *error=nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSString *itel=[parameters objectForKey:@"targetItel"];
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
               
                [[ItelAction action] addItelUserBlackResponse:itel];
            }
            else {
                NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":[dic objectForKey:@"msg"] };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlack" object:nil userInfo:userInfo];
            }
        }
    };
    FAILURE{
        NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"网络异常" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlack" object:nil userInfo:userInfo];
    };
    [self jsonPostRequestWithUrl:url andParameters:parameters success:success failure:failure];
}

#pragma mark - 从黑名单中移除

-(void)removeFromBlackList:(NSDictionary*)parameters;{
   
    NSString *url=[NSString stringWithFormat:@"%@/contact/removeBlack.json",server];
    SUCCESS{
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSString *itel=[parameters objectForKey:@"targetItel"];
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
                
                [[ItelAction action] delFriendFromItelBook:itel];
            }
            else {
                NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"解析异常" };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"removeBlack" object:nil userInfo:userInfo];
            }
        }
    };
    FAILURE{
        NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"网络异常" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeBlack" object:nil userInfo:userInfo];
    };
    [self jsonPostRequestWithUrl:url andParameters:parameters success:success failure:failure];
}

#pragma mark - 编辑用户备注
-(void)editUserRemark:(NSString*)newRemark user:(NSDictionary*)parameters{
   
    NSString *url=[NSString stringWithFormat:@"%@/contact/updateItelFriend.json",server];

    SUCCESS{
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
     
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
                
                [[ItelAction action] editUserAliasResponse:[dic objectForKey:@"data"]];
            }
            else {
                NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":[dic objectForKey:@"msg"] };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAlias" object:nil userInfo:userInfo];
            }
        }
    };
    FAILURE{
        NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"网络异常" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAlias" object:nil userInfo:userInfo];
    };
    [self jsonPostRequestWithUrl:url andParameters:parameters success:success failure:failure];
}

#pragma mark - 刷新好友列表

/*刷新好友列表
 客户端发送
    token：
 成功返回
 data{
 search_result ：[用户1 用户2...]
 }
 
 */
-(void)refreshUserList:(NSDictionary*)parameters{
    
    
   NSString *url=[NSString stringWithFormat:@"%@/contact/loadItelContacts.json",server];
   
    SUCCESS{
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
               
                id data =[dic objectForKey:@"data"];
                [[ItelAction action] getItelFriendListResponse:data ];
            }
            else {
                NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"解析异常" };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getItelList" object:nil userInfo:userInfo];
            }
        }//如果请求失败 则执行failure
    };
    FAILURE {
        NSLog(@"%@",error);
        NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"网络异常" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getItelList" object:nil userInfo:userInfo];
    };
    [self jsonGetRequestWithUrl:url andParameters:parameters success:success failure:failure];
    
}






@end
