//
//  NSCAlertView.m
//  iCloudPhone
//
//  Created by nsc on 13-12-11.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import "NSCAlertView.h"

@implementation NSCAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(80, 20, 60, 20)];
        lb.text=@"123455";
        lb.textColor=[UIColor redColor];
        [self addSubview:lb];
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
