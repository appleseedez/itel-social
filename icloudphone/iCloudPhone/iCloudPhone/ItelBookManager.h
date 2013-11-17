//
//  ItelBookManager.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//  单例负责 itel通讯录的 增删改查

#import <Foundation/Foundation.h>
#import "ItelUser.h"

@interface ItelBookManager : NSObject
+(ItelBookManager*)defaultManager;
#pragma mark - 增删改查
-(BOOL)addUserToItelBook:(ItelUser*)user;
-(BOOL)delUserFromItelBook:(ItelUser*)user;
-(BOOL)replaceUserInItelBook:(ItelUser*)user;
-(id)searchUsersFromItelBook:(NSString*)search;

@end
