//
//  NXRegViewController.m
//  social
//
//  Created by nsc on 13-11-6.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "NXRegViewController.h"
#import "RegManager.h"
@interface NXRegViewController ()

@end

@implementation NXRegViewController


- (IBAction)personalClicked:(UIButton *)sender {
    [RegManager defaultManager].regType=@"0";
}
- (IBAction)priceCLicked:(UIButton *)sender {
    [RegManager defaultManager].regType=@"1";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"regSuccess" object:nil];
        [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消注册" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
   }

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
