//
//  CustonTarbarItem.m
//  iCloudPhone
//
//  Created by nsc on 13-11-28.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "CustonTarbarItem.h"

@implementation CustonTarbarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cusImageView=[[UIImageView alloc]init];
        [self addSubview:self.cusImageView];
     
        self.label = [[UILabel alloc]init];
        [self addSubview:self.label];
        
    }
    return self;
}
-(void)isSelected:(BOOL)selected{
    if (selected) {
        if (self.selectedImage) {
            self.cusImageView.image=self.selectedImage;
        }
        
    }
    else{
        if (self.normalImage) {
            self.cusImageView.image=self.normalImage;

        }
            }
    
}
-(void)setImageViewFrame:(CGRect)frame{
    self.cusImageView.frame=frame;
}
-(void)setLabelFrame:(CGRect)frame{
    self.label.frame=frame;
}
-(void)setLabelTitle:(NSString*)title{
    self.label.text=title;
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
