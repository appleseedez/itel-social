//
//  ItelUserManager.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItelUser.h"
@interface ItelUserManager : NSObject
+(ItelUserManager*)defaultManager;

//呼叫该用户
-(void)callUser:(ItelUser*)user;
//短信邀请该用户
-(void)invideUserByMessage:(ItelUser*)user;

@end
