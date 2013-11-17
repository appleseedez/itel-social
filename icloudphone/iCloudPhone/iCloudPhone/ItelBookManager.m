//
//  ItelBookManager.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ItelBookManager.h"
static ItelBookManager *manager;
@implementation ItelBookManager
+(ItelBookManager*)defaultManager{
    
    if (manager==nil) {
        manager=[[ItelBookManager alloc]init];
    }
    
    return manager;
}

#pragma mark - 增删改查
-(BOOL)addUserToItelBook:(ItelUser*)user{
    return 0;
}
-(BOOL)delUserFromItelBook:(ItelUser*)user{
    return 0;
}
-(BOOL)replaceUserInItelBook:(ItelUser*)user{
    return 0;
}
-(id)searchUsersFromItelBook:(NSString*)search{
    return nil;
}
@end
