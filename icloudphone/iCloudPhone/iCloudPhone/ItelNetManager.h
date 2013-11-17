//
//  ItelNetManager.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//  这个类是负责所有网络接口  是单例

#import <Foundation/Foundation.h>
#import  "ItelUser.h"
@interface ItelNetManager : NSObject
+(ItelNetManager*)defaultManager;
//查找用户
-(void)searchUser:(NSString*)search;
//拨打用户云电话
-(void)callUserWithItel:(NSString*)itelNum;
//访问用户商铺
-(void)visitUserStore:(NSString*)itelNum;
//删除联系人
-(void)delUser:(NSString*)itel;
//添加联系人
-(void)addUser:(NSString*)itel;
//匹配通讯录中联系人
-(void)checkUsersOwnItel:(NSArray*)users;
//添加联系人到黑名单
-(void)addToBlackList:(NSString*)itel;
//从黑名单中移除
-(void)removeFromBlackList:(NSString*)itel;
//编辑用户备注
-(void)editUserRemark:(NSString*)newRemark user:(NSString*)itel;
//刷新好友列表
-(void)refreshUserList;
@end
