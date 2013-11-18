//
//  ItelNetManager.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ItelNetManager.h"
#import "AFNetworking.h"
static ItelNetManager *manager=nil;
@implementation ItelNetManager

+(ItelNetManager*)defaultManager{
    
    if (manager==nil) {
        manager=[[ItelNetManager alloc]init];
    }
    
    return manager;
}
#pragma mark - 添加联系人

/* 添加用户接口：/addItelUser
 客户端发送 字段
 token ： 当前登录用户
 itel ： 要添加的目标联系人
 返回：
 成功或者失败
 */
-(void)addUser:(NSString*)itel{
    
}
#pragma mark - 删除联系人

/* 删除用户接口：/delItelUser
 客户端发送 字段
 token ： 当前登录用户
 itel ： 要删除的目标联系人
 返回：
 成功或者失败
 */
-(void)delUser:(NSString*)itel{
    
}
#pragma mark - 查找用户接口
/* 查找用户接口：/searchItelUser
   客户端发送 字段
    searchMes 类型 string 
    可能是号码 可能是昵称 需要服务器做模糊查找
   成功返回
     data{
         search_result ：[用户1 用户2...]
         }
   其中用户包括一个用户所有属性  没有设置的返回默认值 加密的返回string“sec”
 */
-(void)searchUser:(NSString*)search{
    NSString *searchUser=@"http://10.0.0.117:8080/CloudCommunity/login.json";
    
    //post参数
    NSMutableDictionary *postParameters=[[NSMutableDictionary alloc]init];
    [postParameters setValue:search forKey:@"searchMes"];
    

    void (^success)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[(NSDictionary*)responseObject objectForKey:@"message"];
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
                id  searchResult=[[dic objectForKey:@"data"] objectForKey:@"search_result"];
                [self.searchUserDelegate searchResult:searchResult];
                }
            else {
               }
        }//如果请求失败 则执行failure
    };
    void (^failure)(AFHTTPRequestOperation *operation, NSError *error)   = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
       
    };
     [[AFHTTPRequestOperationManager manager] POST:searchUser parameters:postParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
         
     } success:success failure:failure];
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
   客户端发送 一组电话号码 为string类型 一组不超过10个电话
     tels :[tel1 tel2 tel3... ]
     服务器验证号码是否注册了云电话 返回已有云电话的用户
 成功返回
 data{
      search_result ：[用户1 用户2...]
  }
 
*/
-(void)checkUsersOwnItel:(NSArray*)users{
    
}
#pragma mark - 添加号码到黑名单
/*
    客户端 发送 一个itel用户号码和自己的token服务器建立黑名单关系
     token ：string类型  当前登录用户的token
     itelNum：string类型  黑名单目标号码
     服务器返回：
       成功或者失败
 */
-(void)addToBlackList:(NSString*)itel{
    
}

#pragma mark - 从黑名单中移除
/*
 客户端 发送 一个itel用户号码和自己的token服务器取消黑名单关系
 token ：string类型  当前登录用户的token
 itelNum：string类型  黑名单目标号码
 服务器返回：
 成功或者失败
 */
-(void)removeFromBlackList:(NSString*)itel{
    
}

#pragma mark - 编辑用户备注
/*
 客户端 发送 一个itel用户号码
 token : string
 itelNum：string类型 
 remark : string 新的备注
 服务器返回：
  成功：
     data :{ user: }
 user 包含一个user全部信息
 
 */
-(void)editUserRemark:(NSString*)newRemark user:(NSString*)itel{
    
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
-(void)refreshUserList{
    
}






@end
