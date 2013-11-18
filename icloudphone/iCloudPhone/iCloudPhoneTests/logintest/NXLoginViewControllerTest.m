//
//  NXLoginViewControllerTest.m
//  social
//
//  Created by nsc on 13-11-5.
//  Copyright (c) 2013年 itelland. All rights reserved.
//  登陆页面的单元测试

#import <XCTest/XCTest.h>
#import "NXLoginViewController.h"
#import "NXMockServer.h"
@interface NXLoginViewController ()
-(BOOL)checkUserInput;
-(void)requestToLogin;
-(void)sendRequesturl:(NSString*)url
           parameters:(NSDictionary *)parametrers
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
@interface NXLoginViewControllerTest : XCTestCase
@property (strong,nonatomic) NXLoginViewController *loginVC;
@end

@implementation NXLoginViewControllerTest

- (void)setUp
{
    [super setUp];
    //白盒测试
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    self.loginVC=(NXLoginViewController*)vc;
    /*[UIApplication sharedApplication]获得当前运行的app对象（单例）  
     .delegate 代表当前app的代理对象  
     .window代表当前的窗口（一般app只有一个窗口）
     .rootViewController 代表这个窗口的根视图控制器
     这样我们就取得了当前运行的主程序的根视图控制器
     */
    
    //黑盒测试
    //self.loginVC=[[NXLoginViewController alloc]init];
   //这句话相当于 new（）一个视图控制器 和当前程序没关系

}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testCheckUserInput
{
    self.loginVC.txtUserCloudNumber.text=@"1001";
    self.loginVC.txtUserPassword.text = @"156888az";
    XCTAssertFalse( [self.loginVC checkUserInput], @"");
    
    self.loginVC.txtUserCloudNumber.text=@"10010";
    self.loginVC.txtUserPassword.text = @"156888az";
    XCTAssertFalse( ![self.loginVC checkUserInput], @"");
    
    self.loginVC.txtUserCloudNumber.text=@"10010111";
    self.loginVC.txtUserPassword.text = @"156888az";
    XCTAssertFalse( ![self.loginVC checkUserInput], @"");

}
-(void)testHttpRequest{
    
    //url地址
    NSString *login=@"http://10.0.0.117:8080/CloudCommunity/login.json";
    
    //post参数
    NSMutableDictionary *postParameters=[[NSMutableDictionary alloc]init];
    [postParameters setValue:@"122334" forKey:@"itel"];
    [postParameters setValue:@"23ded21" forKey:@"password"];
    [postParameters setObject:[NSNumber numberWithBool:NO] forKey:@"auto_login"];
    [postParameters setObject:@"ios" forKey:@"type"];
    //发出post请求
    //success封装了一段代码表示如果请求成功 执行这段代码
    static BOOL isWaiting=0;
    void (^success)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        XCTAssertTrue(responseObject, @"请求正常返回流程测试失败");
                //释放主线程 测试结束
                isWaiting=1;
               };
    void (^failure)(AFHTTPRequestOperation *operation, NSError *error)   = ^(AFHTTPRequestOperation *operation, NSError *error) {
        XCTAssertTrue(error, @"请求异常返回流程测试失败");
                isWaiting=1;
    };

    [self.loginVC sendRequesturl:login parameters:postParameters success:success failure:failure];
    //让主线程在这里转圈圈 否则就会退出
    while (!isWaiting) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
}
@end
