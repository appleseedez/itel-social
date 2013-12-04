//
//  IMHomeViewController.h
//  im
//
//  Created by Pharaoh on 13-11-22.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMHomeViewController : UIViewController
- (IBAction)popDialPanel:(UIBarButtonItem *)sender;
- (IBAction)dial:(UIButton *)sender;
- (IBAction)answerDial:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *itelNumberField;

@end
