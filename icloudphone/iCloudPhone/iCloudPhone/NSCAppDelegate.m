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
#define winFrame [UIApplication sharedApplication].delegate.window.bounds
@implementation NSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    RootViewController *rootVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"rootVC"];
    self.RootVC=rootVC;
    [rootVC setSelectedIndex:2];
    //NSLog(@"%@",mainStoryboard);
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
    [self.window makeKeyAndVisible];    // Override point for customization after application launch.
   // [self test];
    
    
    
    return YES;
}
-(void)test{
    /*
     
     
     10000067899	孤岛	15899990022
     10000026678	风云人物	15399990000
     10000017890	刀人	15699990000
     1000002	 tony	15899990001
     1000001	hack	15899990000
     1000003	tracy	15799990000
     
     
     */
    HostItelUser *hostuser=[[HostItelUser alloc]init];
      hostuser.itelNum=@"1000003";
       hostuser.token=@"sdqwieowqkjjksw1";
       hostuser.userId=@"001";
    [ItelUserManager defaultManager].hostUser=hostuser;
     //添加联系人
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testNotification:) name:@"inviteItelUser" object:nil];
    NSArray *array=@[@"10000067899",@"10000026678",@"10000017890",@"1000002",@"1000001",@"10000060000",@"10000060001",@"10000060002",@"10000060003",@"10000060004",@"10000060005"];
    for (NSString *itel in array) {
        [[ItelAction action]inviteItelUserFriend:itel];
    }
    
    //删除联系人
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testNotification:) name:@"delItelUser" object:nil];
    //[[ItelAction action]delFriendFromItelBook:@"10086"];
    //查找陌生人
    //[[ItelAction action]searchStranger:@"10086" newSearch:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testNotification:) name:@"searhStranger" object:nil];
    //匹配通讯录中联系人
    //[[ItelAction action]checkAddressBookMatchingItel];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testNotification:) name:@"checkAddress" object:nil];
    //编辑用户备注
    //[[ItelAction action] editUser:@"10000017890" alias:@"你妹"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testNotification:) name:@"resetAlias" object:nil];
}
-(void)testNotification:(NSNotification*)notification{
    NSLog(@"%@",notification);
}
-(void)changeRootViewController:(setRootViewController)Type{
    
    [UIView beginAnimations:@"memory" context:nil];
    if (Type==RootViewControllerLogin) {
        [self.window setRootViewController:self.loginVC];
    }
    else if(Type==RootViewControllerMain){
        [self.window setRootViewController:self.RootVC];
    }
    [UIView commitAnimations];
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
