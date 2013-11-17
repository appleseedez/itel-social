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
    self.view.frame=winFrame;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
