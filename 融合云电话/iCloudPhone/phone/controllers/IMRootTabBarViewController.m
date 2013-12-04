//
//  IMRootTabBarViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMRootTabBarViewController.h"
#import "ConstantHeader.h"
#import "IMCallingViewController.h"
#import "IMAnsweringViewController.h"
@interface IMRootTabBarViewController ()
@end

@implementation IMRootTabBarViewController

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
#if ROOT_TABBAR_DEBUG
    NSLog(@"tabbar 加载了");
    NSAssert(self.manager, @"注入manager到tabroot失败");
#endif
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotifications];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PRIVATE
- (void) registerNotifications{
    // 当manager要求加载“拨打中”界面时，收到该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentCallingView:) name:PRESENT_CALLING_VIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentAnsweringView:) name:SESSION_PERIOD_REQ_NOTIFICATION object:nil];
}
- (void) removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - HANDLER
- (void) presentCallingView:(NSNotification*) notify{
#if ROOT_TABBAR_DEBUG
    NSLog(@"收到通知，将要加载CallingView");
#endif
//加载“拨号中”界面
    //加载stroyboard
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController* callingViewNavController = [sb instantiateViewControllerWithIdentifier:CALLING_VIEW_CONTROLLER_ID];
    IMCallingViewController* callingViewController = (IMCallingViewController*) callingViewNavController.topViewController;
//    IMCallingViewController* callingViewController = [sb instantiateViewControllerWithIdentifier:CALLING_VIEW_CONTROLLER_ID];
    callingViewController.manager = self.manager;
    callingViewController.callingNotify = notify;
    [self presentViewController:callingViewNavController animated:YES completion:nil];
}
- (void) presentAnsweringView:(NSNotification*) notify{
#if ROOT_TABBAR_DEBUG
    NSLog(@"收到通知，将要加载AnsweringView");
#endif
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
   UINavigationController* answeringViewNavController =[sb instantiateViewControllerWithIdentifier:ANSWERING_VIEW_CONTROLLER_ID];
    IMAnsweringViewController* answeringViewController = (IMAnsweringViewController*) answeringViewNavController.topViewController;
//    IMAnsweringViewController* answeringViewController = [sb instantiateViewControllerWithIdentifier:ANSWERING_VIEW_CONTROLLER_ID];
    answeringViewController.manager = self.manager;
    answeringViewController.callingNotify = notify;
    [self presentViewController:answeringViewNavController animated:YES completion:nil];
}
@end
