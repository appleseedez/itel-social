//
//  NSCAppDelegate.m
//  iCloudPhone
//
//  Created by nsc on 13-11-14.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "NSCAppDelegate.h"
#import "RootViewController.h"
#import "LeftSideBarViewController.h"
#import "ContentViewController.h"

#define winFrame [UIApplication sharedApplication].delegate.window.bounds
@implementation NSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RootViewController *rootVC=[[RootViewController alloc] init];
    [self.window setRootViewController:rootVC];
    
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    
    //NSLog(@"%@",mainStoryboard);
    LeftSideBarViewController *leftSideBarVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"leftSideBar"];
    [rootVC setLeftSideBarViewController:leftSideBarVC];
    leftSideBarVC.rootControllerDelegate=rootVC;
    ContentViewController *contentVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"contentView"];
    contentVC.view.frame=winFrame;
    [rootVC setContentViewController:contentVC];
    
    
    leftSideBarVC.contentVC=contentVC;
    //添加页面
    UINavigationController *addVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"addView"];
    leftSideBarVC.addVC=addVC;
    addVC.view.frame=winFrame;
    //查询页面
    UINavigationController *searchVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"searchView"];
    leftSideBarVC.searchVC=searchVC;
    searchVC.view.frame=winFrame;
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
