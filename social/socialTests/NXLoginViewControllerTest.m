//
//  NXLoginViewControllerTest.m
//  social
//
//  Created by nsc on 13-11-5.
//  Copyright (c) 2013年 itelland. All rights reserved.
//  登陆页面的单元测试

#import <XCTest/XCTest.h>
#import "NXLoginViewController.h"
@interface NXLoginViewController ()
-(BOOL)checkUserInput;
@end
@interface NXLoginViewControllerTest : XCTestCase
@property (strong,nonatomic) NXLoginViewController *loginVC;
@end

@implementation NXLoginViewControllerTest

- (void)setUp
{
    [super setUp];
     UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    self.loginVC=(NXLoginViewController*)vc;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testCheckUserInput
{
    self.loginVC.txtUserCloudNumber.text=@"10010";
    self.loginVC.txtUserPassword.text = @"156888az";
    XCTAssertFalse( [self.loginVC checkUserInput], @"");
    
    self.loginVC.txtUserCloudNumber.text=@"10010";
    self.loginVC.txtUserPassword.text = @"156888az";
    XCTAssertFalse( [self.loginVC checkUserInput], @"");
    
    self.loginVC.txtUserCloudNumber.text=@"10010";
    self.loginVC.txtUserPassword.text = @"156888az";
    XCTAssertFalse( [self.loginVC checkUserInput], @"");

}

@end
