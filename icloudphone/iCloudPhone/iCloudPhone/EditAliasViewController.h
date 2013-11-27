//
//  EditAliasViewController.h
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItelUser;
@interface EditAliasViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) ItelUser *user;
@end
