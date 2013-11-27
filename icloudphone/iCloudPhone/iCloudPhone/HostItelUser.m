//
//  HostItelUser.m
//  iCloudPhone
//
//  Created by nsc on 13-11-21.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "HostItelUser.h"

@implementation HostItelUser
+(HostItelUser*)userWithDictionary:(NSDictionary*)dic{
    HostItelUser *host = [[HostItelUser alloc] init];
    host.domain =[dic objectForKey:@"domain"];
  
    host.port = [dic objectForKey:@"port"];
    host.stunServer=[dic objectForKey:@"stun_server"];
    host.token=[dic objectForKey:@"token"];
    if (host.token==[NSNull null]) {
         host.token=@"djsadfkjafaklfji";
    }
    host.itelNum=[dic objectForKey:@"itel"];
    host.userId=[dic objectForKey:@"user_id"];
    host.nickName=[dic objectForKey:@"nickname"];
    host.imageurl=[dic objectForKey:@"photo"];
    host.countType=[[dic objectForKey:@"user_type"] boolValue];
    host.itelNum=[dic objectForKey:@"itel"];
    return host;
}
@end
