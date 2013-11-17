//
//  AddressBookViewController.h
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook.h"
@interface AddressBookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AddressBookDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
