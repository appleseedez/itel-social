//
//  ItelBookManager.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//  单例负责 itel通讯录的 增删改查

#import <Foundation/Foundation.h>
#import "ItelUser.h"
#import "ItelAction.h"
@class AddressBook;


@interface ItelBookManager : NSObject <ItelBookActionDelegate>




+(ItelBookManager*)defaultManager;
-(AddressBook*)phoneBook;



@end
