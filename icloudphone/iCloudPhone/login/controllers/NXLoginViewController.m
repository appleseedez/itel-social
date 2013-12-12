//
//  NXLoginViewController.m
//  social
//
//  Created by nsc on 13-11-5.
//  Copyright (c) 2013年 itelland. All rights reserved.
//@"http://211.149.144.15:9000/CloudCommunity/login.json"

#import "NXLoginViewController.h"
#import "NXInputChecker.h"
#import "NXRegViewController.h"
#import "NXResetPasswordViewController.h"
#import "NXMockServer.h"
#import "AFNetworking.h"
#import "NSCAppDelegate.h"
#import "RegNextButton.h"

#import "ItelAction.h"
#define mockServer [AFHTTPSessionManager manager]

@interface NXLoginViewController ()
@property (weak, nonatomic) IBOutlet RegNextButton *btnLogin;

@end

@implementation NXLoginViewController
#pragma  mark - 点击空白退出键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

- (IBAction)presentRegViewController:(UIButton *)sender {
    
    NXRegViewController *reg=[[NXRegViewController alloc]init];
    UINavigationController *regVC= [[UINavigationController alloc]initWithRootViewController:reg];
    [self presentViewController:regVC animated:YES completion:^{
        
    }];

}

- (IBAction)presentResetPasswordViewController:(UIButton *)sender{
    
    NXResetPasswordViewController *resetP=[[NXResetPasswordViewController alloc]init];
    UINavigationController *resetNavVC= [[UINavigationController alloc]initWithRootViewController:resetP];
    [self presentViewController:resetNavVC animated:YES completion:^{
        
    }];
}

#pragma mark - 点击登录按钮
- (IBAction)loginButtonPushed:(UIButton *)sender {
    if (![self checkUserInput]) {
         self.txtInuptCheckMessage.text=@"输入不正确";
    }
    else{
        
        [self requestToLogin];
    }
}
-(void)requestToLogin{
    //这是退出键盘的 不用理它
    [self.view endEditing:YES];
    self.txtInuptCheckMessage.text=@"登录中...";
    [self.actWaitingToLogin startAnimating];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://211.149.144.15:9000/CloudCommunity/login.json"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSData *httpBody=[NSJSONSerialization dataWithJSONObject:@{@"itel": self.txtUserCloudNumber.text,@"password":self.txtUserPassword.text} options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:httpBody];

    //success封装了一段代码表示如果请求成功 执行这段代码
    void (^success)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        id json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([json isKindOfClass:[NSDictionary class]]) {
            //NSLog(@"%@",json);
            NSDictionary *dic=[json objectForKey:@"message"];
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
                HostItelUser *host=[HostItelUser userWithDictionary:[dic objectForKey:@"data"]];

                [[ItelAction action] setHostItelUser:host];
                [self.actWaitingToLogin stopAnimating];
                self.txtInuptCheckMessage.text = @"";

                NSCAppDelegate *delegate =   (NSCAppDelegate*) [UIApplication sharedApplication].delegate;
                [delegate changeRootViewController:RootViewControllerMain];
                
                [[ItelAction action] checkAddressBookMatchingItel];
                
                //[[ItelAction action] delFriendFromBlack:@"1000002"];
                //[[ItelAction action] getItelBlackList:0];
            }
            else {
                [self.actWaitingToLogin stopAnimating];
                self.txtInuptCheckMessage.text=[dic objectForKey:@"msg"];
            }
        }//如果请求失败 则执行failure
    };
    void (^failure)(AFHTTPRequestOperation *operation, NSError *error)   = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.actWaitingToLogin stopAnimating];
        self.txtInuptCheckMessage.text = @"网络不通";
    };
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    //[self sendRequesturl:login parameters:postData success:success failure:failure];
    [operation start];

}
-(void)sendRequesturl:(NSString*)url
            parameters:(NSDictionary *)parametrers
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
#ifndef mockServer
     //正常的情况
    [[AFHTTPRequestOperationManager manager]POST:url parameters:parametrers constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:success failure:failure];
#endif
#ifdef mockServer
      [[NXMockServer sharedServer] POST:url parameters:parametrers constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          
      } success:success failure:failure];
#endif
    

    
}
#pragma mark - 检测用户输入

-(BOOL)checkUserInput{
    
    return [NXInputChecker checkCloudNumber:self.txtUserCloudNumber.text]&&[NXInputChecker checkPassword:self.txtUserPassword.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.actWaitingToLogin.hidesWhenStopped=YES;
    self.txtUserCloudNumber.text=@"1000003";
    self.txtUserPassword.text=@"123456";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLogin:) name:@"regSuccess" object:nil];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.btnLogin setUI];
    
}
-(void)autoLogin:(NSNotification*)notification{
    self.txtUserCloudNumber.text=[notification.userInfo objectForKey:@"itel"];
    self.txtUserPassword.text=[notification.userInfo objectForKey:@"password"];
    [self requestToLogin];
}
@end
