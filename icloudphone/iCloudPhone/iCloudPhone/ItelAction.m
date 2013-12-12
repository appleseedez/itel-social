//
//  ItelAction.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ItelAction.h"
#import "ItelUserManager.h"
#import "ItelBookManager.h"
#import "ItelNetManager.h"
@implementation ItelAction
+(ItelAction*)action{
    ItelAction *action=[[ItelAction alloc] init];
    action.itelBookActionDelegate=[ItelBookManager defaultManager];
    action.itelUserActionDelegate=[ItelUserManager defaultManager];
    action.itelNetRequestActionDelegate=[ItelNetManager defaultManager];
    return action;
}
#pragma mark - 获得机主用户
-(HostItelUser*)getHost{
   return  [self.itelUserActionDelegate hostUser];
}
#pragma mark - 设置机主用户
-(void)setHostItelUser:(HostItelUser*)host{
    [self.itelUserActionDelegate setHost:host];
}
#pragma mark - 获得通讯录
-(void) getAddressBook{
     [self.itelBookActionDelegate getAddressBook];
}
#pragma mark - 刷新itel好友列表

-(void) getItelFriendList:(NSInteger)start{
    HostItelUser *hostUser =  [self.itelUserActionDelegate hostUser];
    
    NSDictionary *parameters = @{@"keyWord":hostUser.userId ,@"start":[NSNumber numberWithInteger:start],@"token":hostUser.token,@"limit":[NSNumber numberWithInteger:20]};
    [self.itelNetRequestActionDelegate refreshUserList:parameters];
}
-(void) getItelFriendListResponse:(id)data{
   
    NSArray *list = [data objectForKey:@"list"];
    
    for (NSDictionary *dic in (NSArray*)list) {
        ItelUser *user=[ItelUser userWithDictionary:dic];
        
        
        [self.itelBookActionDelegate resetUserInFriendBook:user];
    }
    
    [self NotifyForNormalResponse:@"getItelList" parameters:data];
}
#pragma mark - 刷新黑名单列表
//刷新黑名单列表
-(void) getItelBlackList:(NSInteger)start{
    HostItelUser *hostUser =  [self.itelUserActionDelegate hostUser];
    
    NSDictionary *parameters = @{@"keyWord":hostUser.userId ,@"start":[NSNumber numberWithInteger:start],@"token":hostUser.token,@"limit":[NSNumber numberWithInteger:20]};
    [self.itelNetRequestActionDelegate refreshBlackList:parameters];
}
-(void) getItelBlackListResponse:(id)data{
    NSArray *list = [data objectForKey:@"list"];
    
    for (NSDictionary *dic in (NSArray*)list) {
        ItelUser *user=[ItelUser userWithDictionary:dic];
        
        
        [self.itelBookActionDelegate resetUserInBlackBook:user];
    }
    
    [self NotifyForNormalResponse:@"getBlackList" parameters:data];
}
#pragma mark - 添加一个好友
/*
  1 获取机主 token  itel userID
  2 发送请求
 */
//查询是否已经添加该联系人
-(BOOL)checkItelAdded:(NSString*)itel{
    return [self.itelBookActionDelegate checkItelInAddedList:itel];
}
-(void)inviteItelUserFriend:(NSString*)itel{
    if (![self checkItelAdded:itel]) {
        
    
     HostItelUser *hostUser =  [self.itelUserActionDelegate hostUser];
    NSDictionary *parameters = @{@"userId":hostUser.userId ,@"hostItel":hostUser.itelNum,@"targetItel":itel,@"token":hostUser.token};
    
    [self.itelNetRequestActionDelegate addUser:parameters];
    }
    else {
        NSDictionary *userInfo=@{@"isNormal": @"0",@"reason":@"该用户已经添加过了" };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"inviteItelUser" object:nil userInfo:userInfo];
    }
}
//回调
-(void)inviteItelUserFriendResponse:(NSString*)itel{
    [self.itelBookActionDelegate addItelUserIntoAddedList:itel];
    [self NotifyForNormalResponse:@"inviteItelUser" parameters:itel];
}
#pragma mark - 删除好友
/*
 1 获取机主 token  itel userID
 2 发送请求
 */
-(void)delFriendFromItelBook:(NSString*)itel{
    HostItelUser *hostUser =  [self.itelUserActionDelegate hostUser];
    NSDictionary *parameters = @{@"userId":hostUser.userId ,@"hostItel":hostUser.itelNum,@"targetItel":itel,@"token":hostUser.token};
    [self.itelNetRequestActionDelegate delUser:parameters];

}
//回调 1通知viewController  2从列表中删除
-(void)delFriendFromItelBookResponse:(NSString*)itel{
    [self.itelBookActionDelegate delItelUserIntoAddedList:itel];
    [self.itelBookActionDelegate delUserFromFriendBook:itel];
    [self NotifyForNormalResponse:@"delItelUser" parameters:nil];
}
#pragma mark - 添加到黑名单
/*
 1 获取机主 token  itel userID
 2 发送请求
 */
-(void) addItelUserBlack:(NSString*)itel{
    HostItelUser *hostUser =  [self.itelUserActionDelegate hostUser];
    NSDictionary *parameters = @{@"userId":hostUser.userId ,@"hostItel":hostUser.itelNum,@"targetItel":itel,@"token":hostUser.token};
    [self.itelNetRequestActionDelegate addToBlackList:parameters];
}
-(void) addItelUserBlackResponse:(NSString*)itel{
    
    [self.itelBookActionDelegate addUserToBlackBook:itel];
    [self NotifyForNormalResponse:@"addBlack" parameters:nil];

}
#pragma mark - 从黑名单移除
//
-(void) delFriendFromBlack:(NSString*)itel{
    HostItelUser *hostUser =  [self.itelUserActionDelegate hostUser];
    NSDictionary *parameters = @{@"userId":hostUser.userId ,@"hostItel":hostUser.itelNum,@"targetItel":itel,@"token":hostUser.token};
    [self.itelNetRequestActionDelegate removeFromBlackList:parameters];
}
-(void) delFriendFromBlackResponse:(NSString*)itel{
    
    [self.itelBookActionDelegate removeUserFromBlackBook:itel];
    [self NotifyForNormalResponse:@"removeBlack" parameters:nil];
}
#pragma  mark - 匹配通讯录好友
/*匹配通讯录中得联系人接口
 1 获得本机所有联系人电话
 2 网络请求
 */
-(void) checkAddressBookMatchingItel{
    
    dispatch_queue_t getPhones=dispatch_queue_create("getPhones", NULL);
    dispatch_async(getPhones, ^{
        NSArray *phones =  [self.itelBookActionDelegate getAddressPhoneNumbers];
        
        [self.itelNetRequestActionDelegate checkAddressBookForItelUser:phones];
    });
    
    
}
/*
  回调：
 
 */
-(void) checkAddressBookMatchingResponse:(NSArray*)matchingItelUsers{
    
    [self.itelBookActionDelegate actionWithItelUserInAddressBook:matchingItelUsers];
    [self NotifyForNormalResponse:@"checkAddress" parameters:nil];
}
#pragma mark - 编辑好友备注
/*
  1 发送请求 
  2 请求返回成功 设置新的备注
 */
-(void) editUser:(NSString*)itel alias:(NSString*)alias{
    HostItelUser *hostUser =  [self.itelUserActionDelegate hostUser];
    NSDictionary *parameters = @{@"userId":hostUser.userId ,@"hostItel":hostUser.itelNum,@"targetItel":itel,@"token":hostUser.token,@"alias":alias};
    
    [self.itelNetRequestActionDelegate editUserRemark:itel user:parameters];
}

-(void)editUserAliasResponse:(NSDictionary*)user{
    ItelUser *u=[ItelUser userWithDictionary:user];
 
        [self.itelBookActionDelegate resetUserInFriendBook:u];

    if (u.isBlack) {
        [self.itelBookActionDelegate resetUserInBlackBook:u];
    }
    [self NotifyForNormalResponse:@"resetAlias" parameters:u];
}
#pragma mark - 查找陌生人
/*
  1 得到查找关键词 发网络请求
 
 */
-(void) searchStranger:(NSString*)searchMessage newSearch:(BOOL)newSearch{
    [self.itelNetRequestActionDelegate searchUser:searchMessage isNewSearch:newSearch];
 
}
//回调
-(void) searchStrangerResponse:(id)response isEnd:(BOOL)isEnd{
    [self NotifyForNormalResponse:@"searchStranger" parameters:response];
}

-(ItelBook*) getFriendBook{
    return [self.itelBookActionDelegate friendBook];
}
//查找好友列表
-(ItelUser*)userInFriendBook:(NSString*)itel{
    return [self.itelBookActionDelegate userInFriendBook:itel];
}
//查找黑名单
-(ItelUser*)userInBlackBook:(NSString*)itel{
    return [self.itelBookActionDelegate userInBlackBook:itel];
}
//模糊查找好友
-(NSArray*)searchInFirendBook:(NSString*)search{
   return  [self.itelBookActionDelegate searchInfirendBook:search];
}
#pragma mark - 响应正常返回的通知(异常由netManager直接通知)

-(void) NotifyForNormalResponse:(NSString*)name parameters:(id)parameters{
    NSDictionary *userInfo=@{@"isNormal": @"1",@"reason":@"0" };
    
    [[NSNotificationCenter defaultCenter]postNotificationName:name object:parameters userInfo:userInfo];
}
@end
