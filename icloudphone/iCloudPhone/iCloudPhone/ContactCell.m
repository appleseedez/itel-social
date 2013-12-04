//
//  ContactCell.m
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell ()

@end

@implementation ContactCell


-(UIView*)backView{
    if (_backView==nil) {
        _backView=[[UIView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_backView];
        UILabel *delPhone=[[UILabel alloc] initWithFrame:CGRectMake(3, 20, 90, 30)];
        delPhone.text=@"打电话";
        [_backView addSubview:delPhone];
        
        UILabel *sendMes=[[UILabel alloc] initWithFrame:CGRectMake(320-3-90, 20, 90, 30)];
        sendMes.text=@"发短信";
        [_backView addSubview:sendMes];
        
        _backView.backgroundColor=[UIColor redColor];
    }
    return _backView;
}
-(UIView*)topView{
    if (_topView==nil) {
        _topView=[[ContactCellTopView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_topView];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self backView];
    self.contentView.frame=self.bounds;
    
    
    //[self.topView addGestureRecognizer:self.gestreRecognizer];
    if (self) {
        self.lbNickName=[[UILabel alloc]init];
        self.lbNickName.frame=CGRectMake(80, 3, 80, 25);
        self.lbNickName.backgroundColor=[UIColor clearColor];
        
        [self.topView addSubview:self.lbNickName];
        
        self.lbAlias=[[UILabel alloc] init];
        self.lbAlias.frame=CGRectMake(80, 28, 220, 40);
        self.lbAlias.backgroundColor=[UIColor clearColor];
        
        [self.lbAlias setFont:[UIFont fontWithName:@"HeiTi SC" size:12]];
        self.lbAlias.numberOfLines=0;
        [self.lbAlias setTextColor:[UIColor grayColor]];
        [self.topView addSubview:self.lbAlias];
        self.topView.cell=self;
        [self.topView addSubview:self.imageView];
        self.currenTranslate=0;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
