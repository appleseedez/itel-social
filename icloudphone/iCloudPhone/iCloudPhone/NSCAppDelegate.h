//
//  NSCAppDelegate.h
//  iCloudPhone
//
//  Created by nsc on 13-11-14.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMManager.h"
@class NXLoginViewController;
@class RootViewController;
typedef NS_ENUM(NSInteger, setRootViewController) {
    RootViewControllerLogin = 1,
    RootViewControllerMain = 1 << 1,
   
};

@interface NSCAppDelegate : UIResponder <UIApplicationDelegate>

-(void)changeRootViewController:(setRootViewController)Type;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL autoLogin;
@property (strong,nonatomic) NXLoginViewController *loginVC;
@property (nonatomic,strong) RootViewController *RootVC;
@property (nonatomic,strong) id <IMManager> manager;
@end
