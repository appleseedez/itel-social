//
//  ItelUser.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ItelUser.h"

@implementation ItelUser
+(ItelUser*)userWithDictionary:(NSDictionary*)dic{
    ItelUser *user=[[ItelUser alloc] init];
    user.itelNum=[dic objectForKey:@"itel"];
    user.userId=[dic objectForKey:@"user_id"];
    user.nickName=[dic objectForKey:@"nickname"];
    user.imageurl=[dic objectForKey:@"photo"];
    user.remarkName=[dic objectForKey:@"alias"];
        //user.telNum=[dic objectForKey:@"phone"];
      //user.remarkName=[dic objectForKey:@"alias"];
    return user;
}
@end
