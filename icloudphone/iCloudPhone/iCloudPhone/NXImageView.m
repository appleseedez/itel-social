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
-(void)setRect{
    [self.layer   setCornerRadius:self.frame.size.height/6.0]; //设置矩形四个圆角半径
    [self.layer   setBorderWidth:5.0]; //边框宽度
    [self.layer   setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
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
