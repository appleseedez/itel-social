//
//  UserViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "UserViewController.h"
#import "EditAliasViewController.h"
#import "ItelAction.h"
@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbShowName;

@property (weak, nonatomic) IBOutlet UILabel *lbItel;

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)popBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)delUser:(UIButton *)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"确定要删除？" message:@"删了就找不回来了哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [[ItelAction action] delFriendFromItelBook:self.user.itelNum];
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}
- (IBAction)editAlias:(UIButton *)sender {

    ItelUser *user=self.user;
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    EditAliasViewController *aliasVC=[storyBoard instantiateViewControllerWithIdentifier:@"editAliasView"];
    aliasVC.user=user;
   [self presentViewController:aliasVC animated:YES completion:^{
       
   }];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self refreshMessage];
   	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAliasChanged:) name:@"resetAlias" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
-(void)userAliasChanged:(NSNotification*)notification{
    ItelUser *user=(ItelUser*)notification.object ;
    self.user=user ;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshMessage];
    });
    
}
@end
