//
//  RegNextButton.m
//  iCloudPhone
//
//  Created by nsc on 13-12-11.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import "RegNextButton.h"

@implementation RegNextButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setUI{
     UIColor *color = [UIColor colorWithRed:0 green:0.4 blue:1 alpha:1];
    self.backgroundColor=color;
    self.bounds=CGRectMake(0, 0, 310, 44.5);
    //[self setTitle:@"下一步" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.layer setCornerRadius:5.0];
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
