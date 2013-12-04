//
//  IMDailViewController.h
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMDailViewController : UIViewController
- (IBAction)voiceDialing:(UIButton *)sender;
- (IBAction)videoDialing:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *backspaceButton;
@property (weak, nonatomic) IBOutlet UILabel *peerAccount;
- (IBAction)dialNumber:(UIButton *)sender;
- (IBAction)backspace:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *selfAccountLabel;

@end
