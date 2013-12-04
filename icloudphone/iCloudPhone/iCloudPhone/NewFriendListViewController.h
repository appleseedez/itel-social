//
//  NewFriendListViewController.h
//  iCloudPhone
//
//  Created by nsc on 13-12-3.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItelAction.h"
@interface NewFriendListViewController : UITableViewController
@property (nonatomic,strong) ItelBook *searchResult;
@property (nonatomic,strong) NSString *searchText;
@end
