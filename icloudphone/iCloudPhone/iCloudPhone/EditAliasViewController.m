//
//  EditAliasViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "EditAliasViewController.h"
#import "ItelAction.h"
@interface EditAliasViewController ()

@end

@implementation EditAliasViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view endEditing:NO];
	// Do any additional setup after loading the view.
}


- (IBAction)didEnd:(UITextField *)sender {
      [self dismissViewControllerAnimated:YES completion:^{
          [[ItelAction action] editUser:self.user.itelNum alias:sender.text];

      }];
    
    
}

@end
