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
@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbShowName;
@property (weak, nonatomic) IBOutlet NXImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *lbItel;
@property (nonatomic,strong) UIWindow *showWindow;
@property (nonatomic,strong) UIButton *rightBarButton;
@end

@implementation UserViewController
-(UIWindow*)showWindow{
    if (_showWindow==nil) {
        _showWindow=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_showWindow setWindowLevel:UIWindowLevelStatusBar];
        _showWindow.backgroundColor=[UIColor clearColor];
        UIButton *backBtn=[[UIButton alloc]initWithFrame:_showWindow.bounds];
        backBtn.backgroundColor=[UIColor grayColor];
        backBtn.alpha=0.5;
        [backBtn addTarget:self action:@selector(cancelWindow) forControlEvents:UIControlEventTouchUpInside];
        [_showWindow addSubview:backBtn];
        UIButton *delUser=[[UIButton alloc]init];
        delUser.frame=CGRectMake(10, 480-40*3, 300, 30);
       [ delUser setTitle:@"删除联系人" forState:UIControlStateNormal];
        [delUser setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        delUser.backgroundColor=[UIColor whiteColor];
        [delUser addTarget:self action:@selector(delUser:) forControlEvents:UIControlEventTouchUpInside];
        [_showWindow addSubview:delUser];
        
        UIButton *addBlack=[[UIButton alloc]init];
        addBlack.frame=CGRectMake(10, 480-40*2, 300, 30);
        [ addBlack setTitle:@"添加黑名单" forState:UIControlStateNormal];
        [addBlack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addBlack.backgroundColor=[UIColor whiteColor];
        [addBlack addTarget:self action:@selector(addToBlack:) forControlEvents:UIControlEventTouchUpInside];
        [_showWindow addSubview:addBlack];
        
        UIButton *editAlias=[[UIButton alloc]init];
        editAlias.frame=CGRectMake(10, 480-40*1, 300, 30);
        [ editAlias setTitle:@"编辑备注" forState:UIControlStateNormal];
        [editAlias setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        editAlias.backgroundColor=[UIColor whiteColor];
        [editAlias addTarget:self action:@selector(editAlias:) forControlEvents:UIControlEventTouchUpInside];
        [_showWindow addSubview:editAlias];
        
        UIButton *cancel=[[UIButton alloc]init];
        cancel.frame=CGRectMake(10, 480-40*0, 300, 30);
        [ cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancel.backgroundColor=[UIColor whiteColor];
        [cancel addTarget:self action:@selector(cancelWindow) forControlEvents:UIControlEventTouchUpInside];
        [_showWindow addSubview:cancel];
    }
    return _showWindow;
}
-(void)cancelWindow{
    [UIView beginAnimations:@"showButton" context:nil];
    [self.showWindow setHidden:YES];
    [UIView commitAnimations];
}
-(void)callWindow{
    [UIView beginAnimations:@"showButton" context:nil];
    [self.showWindow setHidden:NO];
     [UIView commitAnimations];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [self cancelWindow];
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
    //
    UIButton *rightBarButton=[[UIButton alloc]init];
    [self.navigationController.navigationBar addSubview:rightBarButton];
    rightBarButton.frame=CGRectMake(320-40, 5, 30, 30);
    rightBarButton.backgroundColor=[UIColor orangeColor];
    [rightBarButton addTarget:self action:@selector(callWindow) forControlEvents:UIControlEventTouchUpInside];
    self.rightBarButton=rightBarButton;
    [self.imageView setRect];
    //self.navigationController.navigationBarHidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAliasChanged:) name:@"resetAlias" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rightBarButton  removeFromSuperview];
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
