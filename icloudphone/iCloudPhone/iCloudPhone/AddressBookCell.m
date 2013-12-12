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
        self.name=[[UILabel alloc]init];
        self.name.frame=CGRectMake(65, 6, 80, 25);
        self.name.backgroundColor=[UIColor clearColor];
        
        [self.contentView addSubview:self.name];
        
        self.tel=[[UILabel alloc] init];
        self.tel.frame=CGRectMake(65, 20, 220, 40);
        self.tel.backgroundColor=[UIColor clearColor];
        
        [self.tel setFont:[UIFont fontWithName:@"HeiTi SC" size:12]];
        self.tel.numberOfLines=0;
        [self.tel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.tel];
        
        self.imgPhoto=[[NXImageView alloc]initWithFrame:CGRectMake(6, 5, 55, 55)];
        [self.imgPhoto setRect:3.0 cornerRadius:self.imgPhoto.frame.size.width/4.0 borderColor:[UIColor whiteColor]];
        self.imgPhoto.clipsToBounds=YES;
        [self.contentView addSubview:self.imgPhoto];
        self.inviteButton=[[InviteButton alloc]init];
        [self.inviteButton setBackgroundImage:[UIImage imageNamed:@"邀请"] forState:UIControlStateNormal];
        self.inviteButton.frame=CGRectMake(230, 10, 70, 45) ;
        [self.contentView addSubview:self.inviteButton];
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
    self.imgPhoto.image=[UIImage imageNamed:@"本机联系人"];
}   
@end
