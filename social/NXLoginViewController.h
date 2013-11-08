//
//  NXLoginViewController.h
//  social
//
//  Created by nsc on 13-11-5.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtUserCloudNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtUserPassword;
@property (weak, nonatomic) IBOutlet UILabel *txtInuptCheckMessage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actWaitingToLogin;
@end
