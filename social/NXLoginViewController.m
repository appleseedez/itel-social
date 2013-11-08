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
    [self.view endEditing:YES];
    
     NSString *login=@"/login";

    NSMutableDictionary *postParameters=[[NSMutableDictionary alloc]init];
    [postParameters setValue:self.txtUserCloudNumber.text forKey:@"itel"];
    [postParameters setValue:self.txtUserPassword.text forKey:@"password"];
    
    [[NXMockServer sharedServer] POST:login parameters:postParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=(NSDictionary*)responseObject;
            int ret=[[dic objectForKey:@"ret"] intValue];
            if (ret==0) {
                [self.actWaitingToLogin stopAnimating];
                self.txtInuptCheckMessage.text = @"登录成功，此时已经跳到主界面";
            }
            else {
                [self.actWaitingToLogin stopAnimating];
                self.txtInuptCheckMessage.text=[dic objectForKey:@"msg"];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.actWaitingToLogin stopAnimating];
        self.txtInuptCheckMessage.text = @"网络不通";
    }];
}
#pragma mark - 检测用户输入

-(BOOL)checkUserInput{
    
    return [NXInputChecker checkCloudNumber:self.txtUserCloudNumber.text]&&[NXInputChecker checkPassword:self.txtUserPassword.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.actWaitingToLogin.hidesWhenStopped=YES;
	// Do any additional setup after loading the view.
}



@end
