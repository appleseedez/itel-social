//
//  CustomTabbar.m
//  iCloudPhone
//
//  Created by nsc on 13-11-28.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "CustomTabbar.h"
#import "CustonTarbarItem.h"
@implementation CustomTabbar

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
        CustonTarbarItem *itel=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(0, 0,  55, frame.size.height)];
        [itel setImageViewFrame:CGRectMake(0, 0, 30, 30)];
        [itel setLabelFrame:CGRectMake(0, 30, 55, 20)];
        [itel setLabelTitle:@"云电话"];
        [self.items addObject:itel];
        [self addSubview:itel];
        
        CustonTarbarItem *contact=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(55, 0,  55, frame.size.height)];
        [contact setImageViewFrame:CGRectMake(55, 0, 30, 30)];
        [contact setLabelFrame:CGRectMake(0, 30, 55, 20)];
        [contact setLabelTitle:@"联系人"];
        [self.items addObject:contact];
        [self addSubview:contact];
        
        CustonTarbarItem *main=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(110, 0,  55, frame.size.height)];
        [main setImageViewFrame:main.bounds];
        
        
        [self.items addObject:main];
        [self addSubview:main];
        
        CustonTarbarItem *message=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(220, 0,  55, frame.size.height)];
        [message setImageViewFrame:CGRectMake(55, 0, 30, 30)];
        [message setLabelFrame:CGRectMake(0, 30, 55, 20)];
        [message setLabelTitle:@"消息"];
        [self.items addObject:message];
        [self addSubview:message];
        
        CustonTarbarItem *more=[[CustonTarbarItem alloc]initWithFrame:CGRectMake(275, 0,  55, frame.size.height)];
        [more setImageViewFrame:CGRectMake(55, 0, 30, 30)];
        [more setLabelFrame:CGRectMake(0, 30, 55, 20)];
        [more setLabelTitle:@"更多"];
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
