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
        NSLog(@"已经弹出注册页面");
    }];

}

- (IBAction)presentResetPasswordViewController:(UIButton *)sender{
    
    NXResetPasswordViewController *resetP=[[NXResetPasswordViewController alloc]init];
    UINavigationController *resetNavVC= [[UINavigationController alloc]initWithRootViewController:resetP];
    [self presentViewController:resetNavVC animated:YES completion:^{
        NSLog(@"已经弹出密码找回页面");
    }];
}

#pragma mark - 检测用户输入
-(BOOL)checkUserInput{
    
    return [NXInputChecker checkCloudNumber:self.txtUserCloudNumber.text]&&[NXInputChecker checkPassword:self.txtUserPassword.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



@end
