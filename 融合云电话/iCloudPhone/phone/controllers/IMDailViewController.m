//
//  IMDailViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMDailViewController.h"
#import "IMManager.h"
#import "IMRootTabBarViewController.h"
#import "ConstantHeader.h"
#import <AudioToolbox/AudioToolbox.h>
@interface IMDailViewController ()
@property(nonatomic,weak) id<IMManager> manager;
@property(nonatomic) NSDictionary* touchToneMap;
@end

@implementation IMDailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.touchToneMap = @{
                          @"0":[NSNumber numberWithInt:1200],
                          @"1":[NSNumber numberWithInt:1201],
                          @"2":[NSNumber numberWithInt:1202],
                          @"3":[NSNumber numberWithInt:1203],
                          @"4":[NSNumber numberWithInt:1204],
                          @"5":[NSNumber numberWithInt:1205],
                          @"6":[NSNumber numberWithInt:1206],
                          @"7":[NSNumber numberWithInt:1207],
                          @"8":[NSNumber numberWithInt:1208],
                          @"9":[NSNumber numberWithInt:1209],
                          @"*":[NSNumber numberWithInt:1210],
                          @"#":[NSNumber numberWithInt:1211]
                          
                          };
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![self.peerAccount.text length]) {
        self.backspaceButton.hidden = YES;
    }else{
        self.backspaceButton.hidden = NO;
    }
    [self setup];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self tearDown];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)voiceDialing:(UIButton *)sender {
    NSString* peerAccount = self.peerAccount.text;
    if (!peerAccount) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_CALLING_VIEW_NOTIFICATION object:nil userInfo:@{
                                                                                                                       SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY:peerAccount,
                                                                                                                       SESSION_INIT_REQ_FIELD_SRC_ACCOUNT_KEY:[self.manager myAccount]
                                                                                                                       }];
    [self.manager dial:peerAccount];
    
}
- (void) setup{
    [self registerNotifications];
    IMRootTabBarViewController* root =(IMRootTabBarViewController*)self.tabBarController;
    self.manager = root.manager;
}
- (void) tearDown{
    [self removeNotifications];
}
- (void) registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authOK:) name:CMID_APP_LOGIN_SSS_NOTIFICATION object:nil];
}
- (void) removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) authOK:(NSNotification*) notify{
    self.selfAccountLabel.text = [NSString stringWithFormat:@"本机号码：%@", [self.manager myAccount]];
}

- (IBAction)videoDialing:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_CALLING_VIEW_NOTIFICATION object:nil userInfo:nil];
}
- (IBAction)dialNumber:(UIButton *)sender {
    if ([self.peerAccount.text length] >=13) {
        return;
    }
    NSString* currentDig = sender.titleLabel.text;
    AudioServicesPlaySystemSound([[self.touchToneMap valueForKey:currentDig] intValue]);
    NSMutableString* currentSequence =[self.peerAccount.text mutableCopy];
    [currentSequence appendString:currentDig];
    self.peerAccount.text = [currentSequence copy];
    if ([self.peerAccount.text length] > 0) {
        self.backspaceButton.hidden = NO;
    }else{
        self.backspaceButton.hidden = YES;
    }


}

- (IBAction)backspace:(UIButton *)sender {
    NSInteger length = [self.peerAccount.text length];
    if (length == 1) {
        self.backspaceButton.hidden = YES;
    }
    NSString* temp = [self.peerAccount.text substringToIndex:length-1];
    self.peerAccount.text = temp;
}
@end
