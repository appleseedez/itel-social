//
//  NXResetPasswordViewController.m
//  social
//
//  Created by nsc on 13-11-6.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "NXResetPasswordViewController.h"

@interface NXResetPasswordViewController ()

@end

@implementation NXResetPasswordViewController
#pragma  mark - 点击空白退出键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
- (IBAction)sendPasswordEmail:(UIButton *)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"邮件已发送" message:@"请登录您的邮箱xxxxNB@qq.com查收" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
    
}

- (IBAction)dismiss:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"已经退出密码找回页面");
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
