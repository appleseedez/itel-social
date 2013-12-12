//
//  RegDetailViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-12-9.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import "RegDetailViewController.h"
#import "RegManager.h"
#import "NXInputChecker.h"
#import "MBProgressHUD.h"
#import "RegNextButton.h"
#define TXT_ITEL_TAG 500001
#define TXT_PASSWORD_TAG 500002
#define TXT_RE_PASSWORD_TAG 500003
#define TXT_PHONE_NUMBER_TAG 500004

@interface RegDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtItel;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRePassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet RegNextButton *nextButton;
@property (strong,nonatomic) UIView *inputAccessoryView;
@end

@implementation RegDetailViewController
static long currEditingTextTag=0;
static float animatedDuration=1.0;

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currEditingTextTag=textField.tag;
}

-(UIView*)inputAccessoryView{
    if (_inputAccessoryView==nil) {
        _inputAccessoryView=[[UIView alloc]init];
        _inputAccessoryView.bounds=CGRectMake(0, 0, 320, 44);
        _inputAccessoryView.backgroundColor=[UIColor orangeColor];
        UIButton *foreward=[[UIButton alloc]initWithFrame:CGRectMake(60, 0, 88, 44)];
        [foreward setTitle:@"下一个" forState:UIControlStateNormal];
        foreward.backgroundColor=[UIColor purpleColor];
        [foreward addTarget:self action:@selector(chanegeToNextText) forControlEvents:UIControlEventTouchUpInside];
        [_inputAccessoryView addSubview:foreward];
        
        UIButton *backward=[[UIButton alloc]initWithFrame:CGRectMake(60+88, 0, 88, 44)];
        [backward setTitle:@"上一个" forState:UIControlStateNormal];
        backward.backgroundColor=[UIColor purpleColor];
        [backward addTarget:self action:@selector(changeToLast) forControlEvents:UIControlEventTouchUpInside];
        [_inputAccessoryView addSubview:backward];
        
        UIButton *end=[[UIButton alloc]initWithFrame:CGRectMake(320-88, 0, 88, 44)];
        [end setTitle:@"结束" forState:UIControlStateNormal];
        end.backgroundColor=[UIColor purpleColor];
        [end addTarget:self action:@selector(returnKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        [_inputAccessoryView addSubview:end];
    }
    return _inputAccessoryView;
}
-(void)chanegeToNextText{
    UITextField *text=nil;
    float nextTag=0;
    switch (currEditingTextTag) {
        case TXT_ITEL_TAG:
            nextTag=TXT_PASSWORD_TAG;
            break;
        case TXT_PASSWORD_TAG:
            nextTag=TXT_RE_PASSWORD_TAG;
            break;
        case TXT_RE_PASSWORD_TAG:
            nextTag=TXT_PHONE_NUMBER_TAG;
            break;
        case TXT_PHONE_NUMBER_TAG:
            nextTag=TXT_ITEL_TAG;
            break;
            
        default:
            break;
    }
    text=(UITextField*)[self.view viewWithTag:nextTag];
    [text becomeFirstResponder];
}
-(void)changeToLast{
    UITextField *last=nil;
    float nextTag=0;
    switch (currEditingTextTag) {
        case TXT_PASSWORD_TAG:
            nextTag=TXT_ITEL_TAG;
            break;
        case TXT_RE_PASSWORD_TAG:
            nextTag=TXT_PASSWORD_TAG;
            break;
        case TXT_PHONE_NUMBER_TAG:
            nextTag=TXT_RE_PASSWORD_TAG;
            break;
        case TXT_ITEL_TAG:
            nextTag=TXT_PHONE_NUMBER_TAG;
            break;
            
        default:
            break;
    }
    last=(UITextField*)[self.view viewWithTag:nextTag];
    [last becomeFirstResponder];
}
-(void)returnKeyBoard{
    [self.view endEditing:YES];
}
-(void)setSubViewUI{
    [self.nextButton setUI];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubViewUI];
    self.txtItel.inputAccessoryView=self.inputAccessoryView;
    self.txtPassword.inputAccessoryView=self.inputAccessoryView;
    self.txtRePassword.inputAccessoryView=self.inputAccessoryView;
    self.txtPhoneNumber.inputAccessoryView=self.inputAccessoryView;
    UIScrollView *scroll=self.scrollView;
    
    scroll.frame=self.view.frame;
    scroll.contentSize=scroll.bounds.size;
    
    
	// Do any additional setup after loading the view.
}
-(void)conformKeyBoard:(NSNotification *)notification
{
    //NSLog(@"键盘高度即将变化");
    CGFloat keyBoardHeightDelta;
    //获取信件
    NSDictionary *info= notification.userInfo;
    //NSLog(@"通知携带的信息:%@",info);
    CGRect beginRect=[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    keyBoardHeightDelta=beginRect.origin.y-endRect.origin.y;
    UIScrollView *scroll=self.scrollView;
    UIView *txt=[self.view viewWithTag:currEditingTextTag];
    float currTextY=txt.frame.origin.y;
    [UIView animateKeyframesWithDuration:animatedDuration delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        if (keyBoardHeightDelta>0) {
            scroll.frame=CGRectMake(0, 0, scroll.bounds.size.width, scroll.bounds.size.height-keyBoardHeightDelta);
            scroll.contentSize=self.view.bounds.size;
            scroll.contentOffset=CGPointMake(scroll.contentOffset.x, currTextY-scroll.bounds.size.height/2);
        }
        else{
            scroll.frame=self.view.frame ;
            scroll.contentOffset=CGPointMake(0,-54);
        }
       } completion:^(BOOL finished) {
        
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(conformKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:Nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkInputResponse:) name:CHECH_NUM_INTERFACE_NOTIFICATION object:nil];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void) checkInputResponse:(NSNotification*)notification{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *userInfo = notification.userInfo;
    BOOL success=[[userInfo objectForKey:@"success"] boolValue];
        if (success) {
        int ret=[(NSString*)[(NSDictionary*)notification.object objectForKey:@"ret"] intValue];
        NSLog(@"%@",notification.object);
        if (ret==0) {
            //跳转页面
            NSString *alertMessage=[NSString stringWithFormat:@"系统即将给您的手机：%@发送一条验证短信，点击取消将不发送",self.txtPhoneNumber.text];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"将要开始手机验证" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
        else {
            NSString *msg=[(NSDictionary*)notification.object objectForKey:@"msg"];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"验证失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"验证失败" message:@"网络不通" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)checkUserInput:(UIButton *)sender {
    [self returnKeyBoard];
    //[self pushNextView];
    NSString *localCheck=[self checkInputFormat];
    if (localCheck==nil) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        RegManager *manager=[RegManager defaultManager];
        manager.regItel=self.txtItel.text;
        manager.regPassword=self.txtPassword.text;
        manager.regPhoneNumber=self.txtPhoneNumber.text;
        [manager checkNumberInterface];
    }
    else {
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"验证失败" message:localCheck delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}
/*
 1 检测输入
 
 */
-(NSString*)checkInputFormat{
    if (![NXInputChecker checkCloudNumber:self.txtItel.text]) {
        return @"云号码格式不正确";
    }
    if (![NXInputChecker checkPassword:self.txtPassword.text]) {
        return @"密码格式不正确";
    }
    if (![self.txtPassword.text isEqualToString:self.txtRePassword.text]) {
        return @"两次输入密码不一致";
    }
    if (![NXInputChecker checkPhoneNumberIsMobile:self.txtPhoneNumber.text]) {
        return @"密码格式不正确";
    }
    
    
    return nil;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self pushNextView];
        //发送短信验证请求
       
        
        [[RegManager defaultManager] sendMessageInterface];
    }
}
-(void)pushNextView{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Login_iPhone" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"RegMesView"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
