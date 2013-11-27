//
//  ContactCell.m
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lbNickName=[[UILabel alloc]init];
        self.lbNickName.frame=CGRectMake(80, 3, 80, 25);
        self.lbNickName.backgroundColor=[UIColor clearColor];
        
        [self.contentView addSubview:self.lbNickName];
        
        self.lbAlias=[[UILabel alloc] init];
        self.lbAlias.frame=CGRectMake(80, 28, 220, 40);
        self.lbAlias.backgroundColor=[UIColor clearColor];
        
        [self.lbAlias setFont:[UIFont fontWithName:@"HeiTi SC" size:12]];
        self.lbAlias.numberOfLines=0;
        [self.lbAlias setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.lbAlias];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
