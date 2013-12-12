//
//  SearchNavController.m
//  iCloudPhone
//
//  Created by nsc on 13-12-12.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import "SearchNavController.h"
#import "ConstantHeader.h"
#import "IMAnsweringViewController.h"
#import "IMCallingViewController.h"
@interface SearchNavController ()
@property(nonatomic,weak) id<IMManager> manager;
@end

@implementation SearchNavController

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
	// Do any additional setup after loading the view.
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
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
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
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    UINavigationController* answeringViewNavController =[sb instantiateViewControllerWithIdentifier:ANSWERING_VIEW_CONTROLLER_ID];
    IMAnsweringViewController* answeringViewController = (IMAnsweringViewController*) answeringViewNavController.topViewController;
    //    IMAnsweringViewController* answeringViewController = [sb instantiateViewControllerWithIdentifier:ANSWERING_VIEW_CONTROLLER_ID];
    answeringViewController.manager = self.manager;
    answeringViewController.callingNotify = notify;
    [self presentViewController:answeringViewNavController animated:YES completion:nil];
}

@end
