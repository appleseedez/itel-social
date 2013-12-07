//
//  AddViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-15.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "AddViewController.h"
#define winFrame [UIApplication sharedApplication].delegate.window.bounds
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchNewBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchAddressBtn;

@end

@implementation AddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *itelGray=[UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1];
    UIColor *borderColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self.view setBackgroundColor:itelGray];
    self.searchAddressBtn.layer.borderWidth=0.5;
    self.searchAddressBtn.layer.borderColor=borderColor.CGColor;
    self.searchNewBtn.layer.borderColor=borderColor.CGColor;
    self.searchNewBtn.layer.borderWidth=0.5;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"联系人列表" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    self.view.frame=winFrame;
	// Do any additional setup after loading the view.
}
-(void)dismis{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
