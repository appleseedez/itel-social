//
//  IMRootTabBarViewController.h
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMManager.h"
@interface IMRootTabBarViewController : UITabBarController
@property(nonatomic,weak) id<IMManager> manager;
@end
