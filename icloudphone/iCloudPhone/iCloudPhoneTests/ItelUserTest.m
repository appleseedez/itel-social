//
//  ItelUserTest.m
//  iCloudPhone
//
//  Created by nsc on 13-11-25.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ItelUser.h"
@interface ItelUserTest : XCTestCase
@property (nonatomic,strong) ItelUser *user;
@end

@implementation ItelUserTest

- (void)setUp
{
    [super setUp];
    NSDictionary *dic=@{@"itel": @"1001010",
                        @"user_id":@"001",
                        @"photo":@"www.baidu.com",
                        @"nickname":@"流浪的猫"};
    self.user=[ItelUser userWithDictionary:dic];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testUserWithDictionary
{
    
    
    XCTAssertEqual(self.user.itelNum, @"1001010", @"itel错误");
    XCTAssertEqual(self.user.userId, @"001", @"userId错误");
    XCTAssertEqual(self.user.imageurl, @"www.baidu.com", @"图片地址错误");
    XCTAssertEqual(self.user.nickName, @"流浪的猫", @"昵称错误");
    
    
    
}

@end
