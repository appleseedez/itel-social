//
//  ItelNetManager.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//  这个类是负责所有网络接口  是单例

#import <Foundation/Foundation.h>
#import  "ItelUser.h"
#import "ItelAction.h"


@interface ItelNetManager : NSObject <ItelNetRequestActionDelegate>


+(ItelNetManager*)defaultManager;

//拨打用户云电话
-(void)callUserWithItel:(NSString*)itelNum;
//访问用户商铺
-(void)visitUserStore:(NSString*)itelNum;



@end
