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
        self.lbNickName.frame=CGRectMake(65, 6, 80, 25);
        self.lbNickName.backgroundColor=[UIColor clearColor];
        
        [self.topView addSubview:self.lbNickName];
        
        self.lbItelNumber=[[UILabel alloc] init];
        self.lbItelNumber.frame=CGRectMake(65, 20, 220, 40);
        self.lbItelNumber.backgroundColor=[UIColor clearColor];
        
        [self.lbItelNumber setFont:[UIFont fontWithName:@"HeiTi SC" size:12]];
        self.lbItelNumber.numberOfLines=0;
        [self.lbItelNumber setTextColor:[UIColor grayColor]];
        [self.topView addSubview:self.lbItelNumber];
        self.topView.cell=self;
        self.currenTranslate=0;
        
        self.imgPhoto=[[NXImageView alloc]initWithFrame:CGRectMake(6, 5, 55, 55)];
        [self.imgPhoto setRect:3.0 cornerRadius:self.imgPhoto.frame.size.width/4.0 borderColor:[UIColor whiteColor]];
        //¡™£¢∞§¶•ªº–‘“πø¥†®∑œåß∂ƒ©˙∆˚¬…æ«åΩ≈ç√∫µ≤≥÷÷œı˜ÓÔÚÓ˝ÎÏ‰´„Å¸˛Ç◊˜Â¯Ô¨ÁÏÇ˛∏
        self.imgPhoto.clipsToBounds=YES;
        [self.contentView addSubview:self.imgPhoto];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
