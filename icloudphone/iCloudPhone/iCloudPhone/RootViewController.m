//
//  RootViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-18.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "RootViewController.h"
#import "CustomTabbar.h"
#import "CustonTarbarItem.h"
@interface RootViewController ()
@property (nonatomic,strong) CustomTabbar *customTabbar;
@end

@implementation RootViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float height=[UIApplication sharedApplication].delegate.window.bounds.size.height;
    self.customTabbar  =[[CustomTabbar alloc]initWithFrame:CGRectMake(0, height-55, 320, 55)];
    [self.view addSubview:self.customTabbar];
    for (CustonTarbarItem *item in self.customTabbar.items) {
        [item addTarget:self action:@selector(changeController:) forControlEvents:UIControlEventTouchDown];
    }
}
-(void)changeController:(CustonTarbarItem*)sender{
    for (CustonTarbarItem *item in self.customTabbar.items ) {
        [item setSelected:NO];
    }
     [sender setSelected:YES];
    int i= [self.customTabbar.items indexOfObject:sender];
    [self setSelectedIndex:i];
}


@end
