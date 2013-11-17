//
//  RootViewController.h
//  实训项目-宁少春
//
//  Created by nsc on 13-9-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SideBarShowDirection) {
    SideBarShowDirectionNone = 1,
    SideBarShowDirectionLeft = 1 << 1,
    SideBarShowDirectionRight = 1 << 2
};

typedef NS_ENUM(NSInteger, SelectTypeFromLeft) {
    ProductsList = 1,
    LoginForUser = 1 << 1,
    RegisterForUser = 1 << 2,
    SettingForUser=1<<3,
    AboutForSoft=1<<4
    
};
@protocol rootViewControllerDelegate <NSObject>
-(void)setContentViewController:(UIViewController *)contentViewController;
-(void)setLeftSideBarViewController:(UIViewController *)leftSideBarViewController;
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration;
@end

@interface RootViewController : UIViewController<rootViewControllerDelegate>

@end
