//
//  LeftSideBarViewController.h
//  TV
//
//  Created by nsc on 13-10-24.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ContentViewController.h"
#import "AddViewController.h"
@interface LeftSideBarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) ContentViewController *contentVC;
@property (strong,nonatomic) UINavigationController *addVC;
@property (strong,nonatomic) UINavigationController *searchVC;
@property (weak,nonatomic) id <rootViewControllerDelegate> rootControllerDelegate;
@end
