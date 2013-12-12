//
//  RegManager.h
//  iCloudPhone
//
//  Created by nsc on 13-12-10.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CHECH_NUM_INTERFACE_NOTIFICATION  @"checkNumber"
#define CHECH_MES_INTERFACE_NOTIFICATION  @"checkMesCode"
#define COMMIT_INTERFACE_NOTIFICATION  @"commitRegMessage"
#define SERVER_IP @"http://211.149.144.15:9000/CloudCommunity"
#define REG_SUCCESS_NOTIFICATION @"regSuccess"
@interface RegManager : NSObject
+(RegManager*)defaultManager;
-(void) checkNumberInterface;
-(void) sendMessageInterface;
-(void)commitInterfaceCheckCode:(NSString*)CheckCode;
@property (nonatomic,strong)  NSString *regItel;
@property (nonatomic,strong)  NSString *regPassword;
@property (nonatomic,strong)  NSString *regPhoneNumber;
@property (nonatomic,strong)  NSString *regType; //0是个人 1是企业
@end
