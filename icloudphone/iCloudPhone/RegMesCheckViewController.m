//
//  RegMesCheckViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-12-10.
//  Copyright (c) 2013年 NX. All rights reserved.
//

#import "RegMesCheckViewController.h"
#import "RegManager.h"
#import "NSCAlertView.h"
#import "RegNextButton.h"
@interface RegMesCheckViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnReSend;
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet RegNextButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *txtCheckCode;
- (IBAction)messageButton:(UIButton *)sender;
@end

@implementation RegMesCheckViewController
static int waitingTime=60;
-(void)setUI{
    [self.nextButton setUI];
}
-(void)TimerStart{
    waitingTime=60;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerBeat) userInfo:nil repeats:YES];
    self.btnReSend.enabled=NO;

}
-(void)timerEnd{
    [self.timer invalidate] ;
    self.timer = nil;
}
-(void)timerBeat{
    if (waitingTime) {
        waitingTime--;
        [self refreshButton];
    }
    else {
        [self.timer invalidate];
        [self refreshButton];
        
    }
}
-(void)refreshButton{
    NSString  *title=nil;
    if (waitingTime) {
         title=[NSString stringWithFormat:@"(%d秒后)重新发送",waitingTime];
            }
    else{
         title=@"点击重新发送";
        self.btnReSend.enabled=YES;
        [self timerEnd];
    }
    [self.btnReSend setTitle:title forState:UIControlStateNormal];
    [self.btnReSend setTitle:title forState:UIControlStateDisabled];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    [self TimerStart];
    [self.navigationItem.leftBarButtonItem setAction:@selector(pop)];
	// Do any additional setup after loading the view.
}
- (IBAction)checkCode:(UIButton *)sender {
   
  
    

    
    [[RegManager defaultManager] commitInterfaceCheckCode:self.txtCheckCode.text];
}
-(void)pop{
    [self.view endEditing:YES];
 
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCodeResponse:) name:COMMIT_INTERFACE_NOTIFICATION object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self timerEnd];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)checkCodeResponse:(NSNotification*)notification{
    NSDictionary *response=(NSDictionary*)notification.object;
    NSInteger ret=[[response objectForKey:@"ret"] integerValue] ;
    
    if (ret==0) {
         //自动登陆
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"恭喜,注册成功" message:@"iTel号码 10086 已经被您注册，请牢记您的iTel号码，以免丢失" delegate:self cancelButtonTitle:@"返回登陆" otherButtonTitles: nil];
        [alert show];
 
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"验证失败" message:@"验证码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)messageButton:(UIButton *)sender {
    [self TimerStart];
    sender.enabled=NO;
    [[RegManager defaultManager] sendMessageInterface];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSDictionary *userInfo=@{@"itel":[RegManager defaultManager].regItel,@"password":[RegManager defaultManager].regPassword};
 
    [[NSNotificationCenter defaultCenter] postNotificationName:REG_SUCCESS_NOTIFICATION object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
