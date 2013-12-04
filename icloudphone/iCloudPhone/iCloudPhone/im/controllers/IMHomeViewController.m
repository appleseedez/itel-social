//
//  IMHomeViewController.m
//  im
//
//  Created by Pharaoh on 13-11-22.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMHomeViewController.h"
#import "IMManager.h"
#import "IMManagerImp.h"
#import "ConstantHeader.h"
@interface IMHomeViewController ()
@property(nonatomic) id<IMManager> manager;
@property(nonatomic) NSNotification* callingNotification; //弹出的通话接听界面应该有这个属性。测试目的，暂时放在这里
@end

@implementation IMHomeViewController

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
    self.manager = [[IMManagerImp alloc] init];
    [self.manager setup];
    [self registerNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.j
}

- (void) registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentAnswerDialView:) name:SESSION_PERIOD_REQ_NOTIFICATION object:nil];
}

//收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void) presentAnswerDialView:(NSNotification*) notify{
   //弹出通话接听界面
    NSLog(@"有人给你来电话啦~");
    self.callingNotification = notify;
}
- (IBAction)popDialPanel:(UIBarButtonItem *)sender {
    [self.itelNumberField becomeFirstResponder];
}

- (IBAction)dial:(UIButton *)sender {
    [self.manager dial:self.itelNumberField.text];
}

- (IBAction)answerDial:(UIButton *)sender {
    [self.manager acceptSession:self.callingNotification];
}
@end
