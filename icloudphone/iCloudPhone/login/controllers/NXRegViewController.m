//
//  NXRegViewController.m
//  social
//
//  Created by nsc on 13-11-6.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "NXRegViewController.h"

@interface NXRegViewController ()

@end

@implementation NXRegViewController
#pragma  mark - 点击空白退出键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

- (IBAction)dismiss:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"注册页面已经消失");
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    NSLog(@"%f",self.view.frame.size.height);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
