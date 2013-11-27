//
//  StrangerCell.m
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "StrangerCell.h"

@implementation StrangerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lbNickName=[[UILabel alloc]init];
        self.lbNickName.frame=CGRectMake(80, 3, 80, 25);
        self.lbNickName.backgroundColor=[UIColor clearColor];
        
        [self.contentView addSubview:self.lbNickName];
        
        self.lbItelNumber=[[UILabel alloc] init];
        self.lbItelNumber.frame=CGRectMake(80, 28, 220, 40);
        self.lbItelNumber.backgroundColor=[UIColor clearColor];
        
        [self.lbItelNumber setFont:[UIFont fontWithName:@"HeiTi SC" size:12]];
        self.lbItelNumber.numberOfLines=0;
        [self.lbItelNumber setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.lbItelNumber];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
