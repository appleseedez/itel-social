//
//  CustomTabbar.m
//  iCloudPhone
//
//  Created by nsc on 13-11-28.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "CustomTabbar.h"
#import "CustonTarbarItem.h"



#define WINSIZE [UIScreen mainScreen].bounds.size
#define SHADOW_WIDTH 0.5
@implementation CustomTabbar
static float width=65.0;
-(NSMutableArray*)items{
    if (_items==nil) {
        _items=[[NSMutableArray alloc]init];
    }
    return _items;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIColor *tabBackColor=[UIColor colorWithRed:0.93333 green:0.93333 blue:0.93333 alpha:0.93333];
        CALayer *upsetShadow=[CALayer layer];
        upsetShadow.frame=CGRectMake(0, SHADOW_WIDTH, 320, SHADOW_WIDTH);
        upsetShadow.backgroundColor=[UIColor grayColor].CGColor;
        self.backgroundColor=tabBackColor;
        [self.layer addSublayer:upsetShadow];
//        self.layer.borderColor=[UIColor redColor].CGColor;
//        self.layer.borderWidth=2.0;
        CustonTarbarItem *itel=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(0, 0,  width, frame.size.height)];
        [itel setImageViewFrame:itel.bounds];
       // itel.cusImageView.backgroundColor=[UIColor greenColor];
        //[itel setLabelFrame:CGRectMake(0, 30, 55, 20)];
        //[itel setLabelTitle:@"云电话"];
        [self.items addObject:itel];
        [self addSubview:itel];
        itel.normalImage=[UIImage imageNamed:@"tab_1.png"];
        itel.selectedImage=[UIImage imageNamed:@"tab_1a.png"];
        //NSLog(@"%@",itel.normalImage);
        CustonTarbarItem *contact=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(width, 0,  width, frame.size.height)];
        [contact setImageViewFrame:contact.bounds];
        //[contact setLabelFrame:CGRectMake(0, 30, 55, 20)];
        //[contact setLabelTitle:@"联系人"];
        [self.items addObject:contact];
        [self addSubview:contact];
        contact.normalImage=[UIImage imageNamed:@"tab_2.png"];
        contact.selectedImage=[UIImage imageNamed:@"tab_2a.png"];
        
        
        CustonTarbarItem *main=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(120, -25,  74, 74)];
        [main setImageViewFrame:main.bounds];
        main.center=CGPointMake(WINSIZE.width/2, frame.size.height-74/2.0);
        main.normalImage=[UIImage imageNamed:@"itel2_3.png"];
        main.selectedImage=[UIImage imageNamed:@"itel2_3a.png"];
        
        [self.items addObject:main];
        [self addSubview:main];
        
        CustonTarbarItem *message=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(320-width*2, 0,  width, frame.size.height)];
        [message setImageViewFrame:CGRectMake(0, 0, width, frame.size.height)];
        //[message setLabelFrame:CGRectMake(0, 30, 55, 20)];
        //[message setLabelTitle:@"消息"];
        message.normalImage=[UIImage imageNamed:@"tab_4.png"];
        message.selectedImage=[UIImage imageNamed:@"tab_4a.png"];
        [self.items addObject:message];
        [self addSubview:message];
        
        CustonTarbarItem *more=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(320-width, 0,  width, frame.size.height)];
        [more setImageViewFrame:CGRectMake(0, 0, width, frame.size.height)];
       // [more setLabelFrame:CGRectMake(0, 30, 55, 20)];
        
        //[more setLabelTitle:@"更多"];
        
        more.normalImage=[UIImage imageNamed:@"tab_5.png"];
        more.selectedImage=[UIImage imageNamed:@"tab_5a.png"];
        [self.items addObject:more];
        [self addSubview:more];
      
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
