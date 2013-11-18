//
//  NXLoginViewController.m
//  social
//
//  Created by nsc on 13-11-5.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "NXLoginViewController.h"
#import "NXInputChecker.h"
#import "NXRegViewController.h"
#import "NXResetPasswordViewController.h"
#import "NXMockServer.h"
#import "AFNetworking.h"
#import "NSCAppDelegate.h"
#define mockServer [AFHTTPSessionManager manager]

@interface NXLoginViewController ()

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
        self.txtInuptCheckMessage.text=@"登录中...";
        [self.actWaitingToLogin startAnimating];
        [self requestToLogin];
    }
}
-(void)requestToLogin{
    //这是退出键盘的 不用理它
    [self.view endEditing:YES];
    //url地址
     NSString *login=@"http://10.0.0.117:8080/CloudCommunity/login.json";
    
    //post参数
    NSMutableDictionary *postParameters=[[NSMutableDictionary alloc]init];
    [postParameters setValue:self.txtUserCloudNumber.text forKey:@"itel"];
    [postParameters setValue:self.txtUserPassword.text forKey:@"password"];
    [postParameters setObject:[NSNumber numberWithBool:NO] forKey:@"auto_login"];
    [postParameters setObject:@"ios" forKey:@"type"];
     //NSLog(@"%@",postParameters);
    //发出post请求
    
        //success封装了一段代码表示如果请求成功 执行这段代码
    void (^success)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[(NSDictionary*)responseObject objectForKey:@"message"];
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
                [self.actWaitingToLogin stopAnimating];
                self.txtInuptCheckMessage.text = @"登录成功";
                NSCAppDelegate *delegate =    [UIApplication sharedApplication].delegate;
                [delegate changeRootViewController:RootViewControllerMain];
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
    
    [self sendRequesturl:login parameters:postParameters success:success failure:failure];
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
    NSLog(@"%f",self.view.frame.size.height);
	// Do any additional setup after loading the view.
}



@end
