//
//  UserViewController.h
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItelUser.h"
@interface UserViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic,strong) ItelUser *user;
@end
