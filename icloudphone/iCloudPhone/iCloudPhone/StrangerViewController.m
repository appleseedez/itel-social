//
//  StrangerViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-27.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "StrangerViewController.h"
#import "ItelAction.h"
@interface StrangerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbItel;
@property (weak, nonatomic) IBOutlet UILabel *lbShowName;


@end

@implementation StrangerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshMessage];
	// Do any additional setup after loading the view.
}
-(void)refreshMessage{
    if([self.user.remarkName length]>0){
        self.lbShowName.text=[NSString stringWithFormat:@"%@(%@)",self.user.remarkName,self.user.nickName];
    }
    else {
        self.lbShowName.text=self.user.nickName;
    }
    self.lbItel.text = [NSString stringWithFormat:@"itel:%@",self.user.itelNum];
    
}
- (IBAction)addStranger:(UIButton *)sender {
    
    [[ItelAction action] inviteItelUserFriend:self.user.itelNum];
}

- (IBAction)popBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didAddFriend:) name:@"inviteItelUser" object:nil];
}
-(void)didAddFriend:(NSNotification*)notification{
    BOOL isNormal = [[notification.userInfo objectForKey:@"isNormal"]boolValue];
    NSString *result=nil;
    if (isNormal) {
         result=@"添加成功";
    }
    else {
        result = @"添加失败";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:result message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
    [alert show];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
