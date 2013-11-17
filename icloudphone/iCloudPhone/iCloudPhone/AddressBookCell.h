//
//  AddressBookCell.h
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItelUser.h"
#import "PersonInAddressBook.h"
@interface AddressBookCell : UITableViewCell
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *tel;
@property (nonatomic,strong) UILabel *email;
@property (nonatomic,strong) ItelUser *itelUser;
-(void)setCell:(PersonInAddressBook*)person;
@end
