//
//  AddressBookCell.m
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "AddressBookCell.h"

@implementation AddressBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.name=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 60, 20)];
        [self.contentView addSubview:self.name];
        self.tel=[[UILabel alloc]initWithFrame:CGRectMake(80, 30, 120, 20)];
        [self.contentView addSubview:self.tel];
        self.email=[[UILabel alloc]initWithFrame:CGRectMake(80, 50, 60, 20)];
        [self.contentView addSubview:self.email];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCell:(PersonInAddressBook*)person{
    self.name.text=person.name;
    self.tel.text=person.tel;
}
@end
