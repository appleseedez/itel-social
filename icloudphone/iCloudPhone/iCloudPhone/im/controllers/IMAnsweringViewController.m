//
//  IMAnsweringViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMAnsweringViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "IMInSessionViewController.h"
static int soundCount;
@interface IMAnsweringViewController ()

@end

@implementation IMAnsweringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setup];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDown];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setup{
    self.peerAccountLabel.text = [NSString stringWithFormat:@"用户 %@ 来电...", [self.callingNotify.userInfo valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY]];
    soundCount = 0;//给拨号音计数，响八次就可以结束
    //系统声音播放是一个异步过程。要循环播放则必须借助回调
    AudioServicesAddSystemSoundCompletion(DIALING_SOUND_ID,NULL,NULL,soundPlayCallback1,NULL);
    AudioServicesPlaySystemSound(DIALING_SOUND_ID);
    [self registerNotifications];
}
- (void) tearDown{
    //终止拨号音
    AudioServicesRemoveSystemSoundCompletion(DIALING_SOUND_ID);
    AudioServicesDisposeSystemSoundID(DIALING_SOUND_ID);
    [self removeNotifications];
}
//循环播放声音
void soundPlayCallback1(SystemSoundID soundId, void *clientData){
    if (soundCount>9) {
        AudioServicesRemoveSystemSoundCompletion(DIALING_SOUND_ID);
        AudioServicesDisposeSystemSoundID(DIALING_SOUND_ID);
    }
    soundCount++;
    AudioServicesPlaySystemSound(DIALING_SOUND_ID);
}

- (void) registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionClosed:) name:END_SESSION_NOTIFICATION object:nil];
}
- (void) removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) sessionClosed:(NSNotification*) notify{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - USER INTERACT
- (IBAction)answerCall:(UIButton *)sender {
    [self.manager acceptSession:self.callingNotify];
    [self performSegueWithIdentifier:@"acceptSessionSegue" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"acceptSessionSegue"]) {
        IMInSessionViewController* inSessionController = (IMInSessionViewController*) segue.destinationViewController;
        IMAnsweringViewController* target = (IMAnsweringViewController*) sender;
        inSessionController.manager = target.manager;
        inSessionController.inSessionNotify = target.callingNotify;
        
    }
}
- (IBAction)refuseCall:(UIButton *)sender {
    //终止会话
    NSMutableDictionary* refusedSessionNotifyMut = [self.callingNotify.userInfo mutableCopy];
    [refusedSessionNotifyMut addEntriesFromDictionary:@{
                                                  SESSION_HALT_FIELD_TYPE_KEY:SESSION_HALT_FILED_ACTION_REFUSE
                                                  }];
    [self.manager haltSession:refusedSessionNotifyMut];
    [self sessionClosed:nil];
}
@end
