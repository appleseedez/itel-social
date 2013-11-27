//
//  ItelUserManager.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItelAction.h"
#import "HostItelUser.h"

@interface ItelUserManager : NSObject <ItelUserActionDelegate>
@property (nonatomic,strong) HostItelUser *hostUser;
+(ItelUserManager*)defaultManager;




@end
