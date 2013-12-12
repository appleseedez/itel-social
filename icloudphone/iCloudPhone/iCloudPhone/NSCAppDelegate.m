//
//  NSCAppDelegate.m
//  iCloudPhone
//
//  Created by nsc on 13-11-14.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "NSCAppDelegate.h"
#import "RootViewController.h"
#import "ItelBookManager.h"
#import "ContentViewController.h"
#import "NXLoginViewController.h"
#import "ItelNetManager.h"
#import "ItelUserManager.h"
//IMmanager 实现类
#import "IMManagerImp.h"
#define winFrame [UIApplication sharedApplication].delegate.window.bounds
@implementation NSCAppDelegate
-(void) signOut{
    [[ItelAction action] setHostItelUser:nil];
    [self changeRootViewController:RootViewControllerLogin];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOut) name:@"signOut" object:nil];
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    RootViewController *rootVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"rootVC"];
    self.manager = [[IMManagerImp alloc] init];
    //[self.manager setup];
    rootVC.manager=self.manager;
    self.RootVC=rootVC;
    [rootVC setSelectedIndex:2];
    
   //===========================登陆注册=============================
    UIStoryboard *loginStoryboard=[UIStoryboard storyboardWithName:@"Login_iPhone" bundle:nil];
    
    NXLoginViewController *loginVC=[loginStoryboard instantiateViewControllerWithIdentifier:@"login"];
    self.loginVC=loginVC;
    
    self.autoLogin=0;
    
   [[ItelBookManager defaultManager] phoneBook];
    
    if (self.autoLogin) {
        [self.window setRootViewController:rootVC];
    }
    else {
        [self.window setRootViewController:loginVC];
        
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
   return YES;
}

-(void)changeRootViewController:(setRootViewController)Type{
    
    [UIView beginAnimations:@"memory" context:nil];
    if (Type==RootViewControllerLogin) {
        [self.window setRootViewController:self.loginVC];
        [self.manager tearDown];
        [self.manager disconnectToSignalServer];
        [self.manager setMyAccount:nil];
    }
    else if(Type==RootViewControllerMain){
        [self.window setRootViewController:self.RootVC];
        [self.manager setup];
        NSString *hostItel=[[ItelAction action]getHost].itelNum;
        [self.manager setMyAccount:hostItel ];
        [self.manager connectToSignalServer];
    }
    [UIView commitAnimations];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationWillResignActive");
#endif
    
    [self.manager disconnectToSignalServer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationDidEnterBackground");
#endif
     
    [self.manager tearDown];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationWillEnterForeground ");
#endif
    if ([[ItelAction action] getHost]) {
        [self.manager setup];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationDidBecomeActive ");
#endif
     if ([[ItelAction action] getHost]) {
    [self.manager connectToSignalServer];
     }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationWillTerminate");
#endif
    [self.manager tearDown];
}

@end
