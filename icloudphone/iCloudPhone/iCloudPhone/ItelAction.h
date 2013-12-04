//
//  ItelAction.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//  用来封装对itel电话本操作的动作 用不用另说

#import <Foundation/Foundation.h>
#import "HostItelUser.h"
@class ItelBook;
#pragma  mark - 联系人列表操作协议
@protocol ItelBookActionDelegate <NSObject>
//从好友列表中删除联系人
-(void)delUserFromFriendBook:(NSString*)itel;
//添加黑名单
-(void)addUserToBlackBook:(NSString*)itel;
//从黑名单移除
-(void)removeUserFromBlackBook:(NSString*)itel;
//获得本机通讯录电话
-(NSArray*)getAddressPhoneNumbers;
//找到已有itel用户
-(void)actionWithItelUserInAddressBook:(NSArray*)itelUsers;
//设置备注 好友
-(void)resetUserInFriendBook:(ItelUser*)user;
//设置备注 黑名单
-(void)resetUserInBlackBook:(ItelUser*)user;
//获得通讯录
-(void)getAddressBook;
//获得联系人列表
-(ItelBook*)friendBook;
//查询用户在等待确认列表
-(BOOL)checkItelInAddedList:(NSString*)itel;
//添加用户到等待确认列表
-(void)addItelUserIntoAddedList:(NSString *)itel;
//删除用户从等待确认列表
-(void)delItelUserIntoAddedList:(NSString *)itel;
@end

#pragma  mark - 用户操作协议
@protocol ItelUserActionDelegate <NSObject>
//本机用户
-(HostItelUser*)hostUser;
//设置本机用户
-(void)setHost:(HostItelUser*)host;

//设置好友
-(void)setUser:(ItelUser*)user friend:(BOOL) isFriend;
//设置黑名单
-(void)setUser:(ItelUser*)user black:(BOOL) isBlack;
//呼叫该用户
-(void)callUser:(ItelUser*)user;
//短信邀请该用户
-(void)invideUserByMessage:(ItelUser*)user;
@end


#pragma mark - 网络请求协议

@protocol ItelNetRequestActionDelegate <NSObject>

//匹配通讯录中联系人
-(void)checkAddressBookForItelUser:(NSArray*)phones;
//查找陌生人
-(void)searchUser:(NSString*)search isNewSearch:(BOOL)isNewSearch;
//添加联系人
-(void)addUser:(NSDictionary*)parameters;
//删除联系人
-(void)delUser:(NSDictionary*)parameters;
//添加联系人到黑名单
-(void)addToBlackList:(NSDictionary*)parameters;
//从黑名单中移除
-(void)removeFromBlackList:(NSDictionary*)parameters;
//编辑用户备注
-(void)editUserRemark:(NSString*)newRemark user:(NSDictionary*)parameters;
//刷新好友列表
-(void)refreshUserList:(NSDictionary*)parameters;
//刷新黑名单列表
-(void)refreshBlackList:(NSDictionary*)parameters;
@end
@interface ItelAction : NSObject
@property (nonatomic,weak) id <ItelBookActionDelegate> itelBookActionDelegate;
@property (nonatomic,weak) id <ItelUserActionDelegate> itelUserActionDelegate;
@property (nonatomic,weak) id <ItelNetRequestActionDelegate>itelNetRequestActionDelegate;
+(ItelAction*)action;
//获得机主用户
-(HostItelUser*)getHost;
//设置机主用户
-(void)setHostItelUser:(HostItelUser*)host;

#pragma  mark - 网络请求
//匹配通讯录好友
-(void) checkAddressBookMatchingItel;
-(void) checkAddressBookMatchingResponse:(NSArray*)matchingItelUsers;
//查找陌生人
-(void) searchStranger:(NSString*)searchMessage newSearch:(BOOL)newSearch;
-(void) searchStrangerResponse:(id)response isEnd:(BOOL)isEnd;
//添加好友
-(void) inviteItelUserFriend:(NSString*)itel;
-(void) inviteItelUserFriendResponse:(NSString*)itel;
//删除好友
-(void) delFriendFromItelBook:(NSString*)itel;
-(void) delFriendFromItelBookResponse:(NSString*)itel;
//添加到黑名单
-(void) addItelUserBlack:(NSString*)itel;
-(void) addItelUserBlackResponse:(NSString*)itel;
//从黑名单移除
-(void) delFriendFromBlack:(NSString*)itel;
-(void) delFriendFromBlackResponse:(NSString*)itel;
//编辑好友备注
-(void) editUser:(NSString*)itel alias:(NSString*)alias;
-(void) editUserAliasResponse:(NSDictionary*)user;
//刷新itel好友列表
-(void) getItelFriendList:(NSInteger)start;
-(void) getItelFriendListResponse:(id)data;
//刷新黑名单列表
-(void) getItelBlackList:(NSInteger)start;
-(void) getItelBlackListResponse:(id)data;
//获得通讯录
-(void) getAddressBook;
//获得itel好友列表
-(ItelBook*) getFriendBook;


//查询是否已经添加该联系人
-(BOOL)checkItelAdded:(NSString*)itel;


@end
