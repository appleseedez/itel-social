//
//  NXInputChecker.m
//  social
//
//  Created by nsc on 13-11-5.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "NXInputChecker.h"

@implementation NXInputChecker
+(BOOL)checkCloudNumber:(NSString*)cloudNumber{
   //非空检测
    if (![NXInputChecker checkEmpty:cloudNumber]) {
        return NO;
    }
    
    //云号码 首位非0检测
    int firstNum=[[cloudNumber substringWithRange:NSMakeRange(0, 1)] intValue];
    if (firstNum==0) {
        return NO;
    }
     //云号码位数检测（5-11位）
    NSUInteger length=[cloudNumber length];
    if ((length<5)||(length>11)) {
        return NO;
    }
    
    return YES;
}
+(BOOL)checkPassword:(NSString*)password{
    //非空检测
    if (![NXInputChecker checkEmpty:password]) {
        return NO;
    }
    
    
    NSUInteger passLength=[password length];
    if (passLength<6) {
        return NO;
    }
    
    
    return YES;
}
//非空检测
+(BOOL)checkEmpty:(NSString *)string{
    if (string==nil) {
        return NO;
    }
    NSString *filteEmpty = [NXInputChecker filterStringWithString:string targetString:@" " replaceWithString:@""];
    if ([filteEmpty isEqualToString:@""]||[filteEmpty isEqualToString:@" "]||[filteEmpty isEqualToString:@"  "]||[filteEmpty isEqualToString:@"   "]) {
        return NO;
    }
    return YES;
}
#pragma mark - 字符串过滤
+(NSString *)filterStringWithString:(NSString*)string targetString:(NSString*)targetString replaceWithString:(NSString*)newString{
    NSMutableString *oldStr=[string mutableCopy];
    NSUInteger lenth=[targetString length];
    NSInteger count=[oldStr length]-lenth;
    for (int i=0; i<count; i++) {
        
        NSRange range;
        range.location=i; range.length=lenth;
        NSString *s =  [oldStr substringWithRange:range];
        if ([s isEqualToString:targetString]) {
            [oldStr replaceCharactersInRange:range withString:newString];
            count = count-(range.length-[newString length]);
        }
        
    }
    NSString *newStr=[oldStr copy];
    //NSLog(@"newStr = %lu",(unsigned long)[newStr length]);
    return newStr;
}

//检查是否为手机号码
+(BOOL)checkPhoneNumberIsMobile:(NSString*)phoneNumber{
   
        return YES;
   
        
}
//把手机号码设置为标准11位
+(NSString*)resetPhoneNumber11:(NSString*)phoneNumber;{
    phoneNumber =[NXInputChecker filterStringWithString:phoneNumber targetString:@" " replaceWithString:@""];
    phoneNumber =[NXInputChecker filterStringWithString:phoneNumber targetString:@"+86" replaceWithString:@""];
    phoneNumber =[NXInputChecker filterStringWithString:phoneNumber targetString:@"-" replaceWithString:@""];
    return phoneNumber;
    
}
#pragma mark - 数组转化为字符串
+(NSString*)changeArrayToString:(NSArray*)array{
       NSString *result=@"";
    for (NSString *s in array) {
        if ([s isKindOfClass:[NSString class]]) {
            if (![array indexOfObject:s] ) {
               result = [result stringByAppendingString:s];
            }
            else{
                result=[NSString stringWithFormat:@"%@,%@",result,s];
            }
        }
    }
     
    return result;
}
@end
