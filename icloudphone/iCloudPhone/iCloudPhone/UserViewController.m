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
#import "NXImageView.h"
#import "IMManager.h"
#import "NSCAppDelegate.h"
@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbShowName;
@property (weak, nonatomic) IBOutlet NXImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lbItel;


@end

@implementation UserViewController
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return @"基本资料";
            break;
            
        case 2:
            return @"传统电话";
            break;
            
        default:
            break;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell.textLabel setFont:[UIFont fontWithName:@"HeiTi SC" size:12]];
    UILabel *prop=[[UILabel alloc]init];
        [cell.contentView addSubview:prop];
                   prop.frame=CGRectMake(80, 5, 120, 20);
    [prop setTextColor:[UIColor grayColor]];
    [prop setFont:[UIFont fontWithName:@"HeiTi SC" size:11]];
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
                 cell.textLabel.text=@"姓名";
                 prop.text=@"谢霆锋";
                break;
            case 1:
                cell.textLabel.text=@"性别";
                break;
            case 2:
                cell.textLabel.text=@"城市";
                prop.text=@"中国-重庆市-九龙坡区";
                break;
            case 3:
                cell.textLabel.text=@"邮箱";
                prop.text = @"123456@qq.com";
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section==2){
        cell.textLabel.text=@"手机";
        prop.text=@"13648345272";
    }
    else if (indexPath.section==0){
        cell.textLabel.text=@"签名";
        prop.frame=CGRectMake(80, 5, 200, 30);
        [prop setNumberOfLines:0];
        prop.text=@"路要一步一步的走，步子迈太大容易扯着蛋.......";
    }
    
    return cell;
}
#pragma mark - 打电话
- (IBAction)callUser:(UIButton *)sender {
    NSCAppDelegate *appDelegate = (NSCAppDelegate*)[UIApplication sharedApplication].delegate;
    HostItelUser *host=[[ItelAction action] getHost];
    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_CALLING_VIEW_NOTIFICATION object:nil userInfo:@{
                                                                                                                       SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY:self.user.itelNum,
                                                                                                                       SESSION_INIT_REQ_FIELD_SRC_ACCOUNT_KEY:host.itelNum
                                                                                                                       }];
    [appDelegate.manager dial:self.user.itelNum];
    
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
- (void)delUser:(UIButton *)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"确定要删除？" message:@"删了就找不回来了哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
    
}
- (void)editAlias:(UIButton *)sender {

    ItelUser *user=self.user;
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    EditAliasViewController *aliasVC=[storyBoard instantiateViewControllerWithIdentifier:@"editAliasView"];
    aliasVC.user=user;
    
   [self presentViewController:aliasVC animated:YES completion:^{
       
   }];
}
- (void)addToBlack:(UIButton *)sender {
    [[ItelAction action] addItelUserBlack:self.user.itelNum];
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
    //self.navigationController.navigationBarHidden=YES;
    [self refreshMessage];
    
   	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.imageView setRect:5.0 cornerRadius:self.imageView.frame.size.width/6.0 borderColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(callActionSheet) ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAliasChanged:) name:@"resetAlias" object:nil];
}
-(void)callActionSheet{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除联系人" otherButtonTitles:@"添加黑名单",@"编辑备注", nil];
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self delUser:nil];
            break;
        case 2:
            [self editAlias:nil];
            break;
        case 1:
            [self addToBlack:nil];
            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 40;
    }
    else return 30;
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
