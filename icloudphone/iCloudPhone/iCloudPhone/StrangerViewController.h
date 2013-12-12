//
//  StrangerViewController.h
//  iCloudPhone
//
//  Created by nsc on 13-11-27.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItelUser;
@interface StrangerViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ItelUser *user;
@end
