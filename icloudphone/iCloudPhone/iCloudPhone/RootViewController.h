//
//  RootViewController.h
//  iCloudPhone
//
//  Created by nsc on 13-11-18.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMManager.h"
@interface RootViewController : UITabBarController
@property (nonatomic,weak) id <IMManager> manager;
@end
