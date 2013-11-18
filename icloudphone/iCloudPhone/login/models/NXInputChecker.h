//
//  NXInputChecker.h
//  social
//
//  Created by nsc on 13-11-5.
//  Copyright (c) 2013年 itelland. All rights reserved.
//  专门提供各种输入检测

#import <Foundation/Foundation.h>

@interface NXInputChecker : NSObject
+(BOOL)checkCloudNumber:(NSString*)cloudNumber;
+(BOOL)checkPassword:(NSString*)password;
+(BOOL)checkEmpty:(NSString *)string;
+(NSString *)filterStringWithString:(NSString*)string targetString:(NSString*)targetString replaceWithString:(NSString*)newString;
@end
