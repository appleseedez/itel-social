//
//  PersonInAddressBook.h
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "ItelUser.h"
@interface PersonInAddressBook : ItelUser
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *tel;

@property (nonatomic,strong) ItelUser *itelUser;
@end
