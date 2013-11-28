//
//  ItelUserManager.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ItelUserManager.h"
static ItelUserManager *manager;
@implementation ItelUserManager
+(ItelUserManager*)defaultManager{
    if (manager==nil) {
        manager=[[ItelUserManager alloc]init];
    }
    return manager;
}
-(void)setHost:(HostItelUser*)host{
    self.hostUser=host;
}
-(void)callUser:(ItelUser*)user{
    
}

@end
