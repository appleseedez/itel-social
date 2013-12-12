//
//  HostItelUser.h
//  iCloudPhone
//
//  Created by nsc on 13-11-21.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ItelUser.h"

@interface HostItelUser : ItelUser
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *domain;
@property (nonatomic,strong) NSString *port;
@property (nonatomic,strong) NSString *stunServer;
@property (nonatomic,strong) NSString *sessionId;
+(HostItelUser*)userWithDictionary:(NSDictionary*)dic;
@end
