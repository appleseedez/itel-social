//
//  ItelUser.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItelUser : NSObject
@property (nonatomic,strong) NSString *itelNum;    //itel号码
@property (nonatomic,strong) NSString *telNum;     // 电话号码
@property (nonatomic,strong) NSString *imageurl;   //头像地址
@property (nonatomic)        BOOL sex;             //性别
@property (nonatomic)        BOOL countType;       //账号类型
@property (nonatomic,strong) NSString *nickName;   //昵称
@property (nonatomic,strong) NSString *remarkName; //备注
@end
