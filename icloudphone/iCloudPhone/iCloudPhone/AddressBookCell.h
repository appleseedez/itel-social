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
#import "NXImageView.h"
#import "InviteButton.h"
@interface AddressBookCell : UITableViewCell
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *tel;
@property (nonatomic,strong) UILabel *email;
@property (nonatomic,strong) ItelUser *itelUser;
@property (nonatomic,strong) NXImageView *imgPhoto;
@property (nonatomic,strong) InviteButton *inviteButton;
-(void)setCell:(PersonInAddressBook*)person;
@end
