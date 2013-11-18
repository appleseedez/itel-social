//
//  NXInputCheckerTest.m
//  social
//
//  Created by nsc on 13-11-5.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NXInputChecker.h"
@interface NXInputCheckerTest : XCTestCase

@end

@implementation NXInputCheckerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}
#pragma mark - 检测云号码输入
- (void)testCheckCloudNum
{
    // 检测非空
    NSString *rightNil=nil;
    XCTAssertFalse([NXInputChecker checkCloudNumber:rightNil], @"云号码非空检测失败");
   // 2 检测 首位是否为0
        NSString *right=@"123456";
    XCTAssertFalse(![NXInputChecker checkCloudNumber:right], @"云号码首位0检测失败");
        NSString *wrong=@"012345";
    XCTAssertFalse([NXInputChecker checkCloudNumber:wrong], @"云号码首位0检测失败");
    // 3 检测 号码长度
        NSString *right_5=@"12345";
    XCTAssertFalse(![NXInputChecker checkCloudNumber:right_5], @"云号码长度检测失败");
    NSString *right_11=@"12345678901";
    XCTAssertFalse(![NXInputChecker checkCloudNumber:right_11], @"云号码长度检测失败");
    NSString *wrong_5=@"1234";
    XCTAssertFalse([NXInputChecker checkCloudNumber:wrong_5], @"云号码长度检测失败");
    NSString *wrong_11=@"123456789012";
    XCTAssertFalse([NXInputChecker checkCloudNumber:wrong_11], @"云号码长度检测失败");
    //如果一个测试里有很多断言 它们会依次执行 无论上一个成功失败执行完成后 会列出失败的断言 所以某种意义上 断言也可以理解为一个独立的测试
}

-(void)testCheckPassword{
    //非空检测
    NSString *rightNil=nil;
    XCTAssertFalse([NXInputChecker checkPassword:rightNil], @"密码长度检测失败");
    
    //检测密码长度
      NSString *right=@"2ddassw";
    XCTAssertFalse(![NXInputChecker checkPassword:right], @"密码长度检测失败");
    NSString *wrong=@"2dda";
    XCTAssertFalse([NXInputChecker checkPassword:wrong], @"密码长度检测失败");
    NSString *edge=@"2dda23";
    XCTAssertFalse(![NXInputChecker checkPassword:edge], @"密码长度检测失败");
    
}
-(void)testCheckEmpty{
    NSString *rightNil=nil;
    XCTAssertFalse([NXInputChecker checkEmpty:rightNil], @"密码非空检测失败");
    NSString *rightEmpty=@"      ";
    XCTAssertFalse([NXInputChecker checkEmpty:rightEmpty], @"密码非空检测失败");
}
@end
