//
//  NXQuestionResetViewController.m
//  social
//
//  Created by nsc on 13-11-6.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "NXQuestionResetViewController.h"

@interface NXQuestionResetViewController ()

@end

@implementation NXQuestionResetViewController

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)pop:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
