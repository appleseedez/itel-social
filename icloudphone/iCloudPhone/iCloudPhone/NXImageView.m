//
//  NXImageView.m
//  iCloudPhone
//
//  Created by nsc on 13-12-3.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import "NXImageView.h"

@implementation NXImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setRect:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor*)borderColor{
    [self.layer   setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
    [self.layer   setBorderWidth:borderWidth]; //边框宽度
    [self.layer   setBorderColor:borderColor.CGColor];//边框颜色
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
