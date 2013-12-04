//
//  IMCallingViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMCallingViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ConstantHeader.h"
#import "IMInSessionViewController.h"
static int soundCount;
@interface IMCallingViewController ()
@property(nonatomic) NSNotification* inSessionNotify;
@end

@implementation IMCallingViewController

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
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelCalling:(UIButton *)sender {
    NSMutableDictionary* cancelCallNotifyMut = [self.callingNotify.userInfo mutableCopy];
    [cancelCallNotifyMut addEntriesFromDictionary:@{
                                                  SESSION_HALT_FIELD_TYPE_KEY:SESSION_HALT_FILED_ACTION_END
                                                  }];
    [self.manager haltSession:cancelCallNotifyMut];
    [self sessionClosed:nil];
}

- (void) setup{
    self.peerAccountLabel.text = [NSString stringWithFormat:@"呼叫用户 %@",[self.callingNotify.userInfo valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY]];
    //开始拨号了。播放声音
    soundCount = 0;//给拨号音计数，响八次就可以结束
    //系统声音播放是一个异步过程。要循环播放则必须借助回调
    AudioServicesAddSystemSoundCompletion(DIALING_SOUND_ID,NULL,NULL,soundPlayCallback,NULL);
    AudioServicesPlaySystemSound(DIALING_SOUND_ID);
    //监听 "PRESENT_INSESSION_VIEW_NOTIFICATION"// 通知加载“通话中界面”
    [self registerNotifications];
}

- (void) tearDown{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //终止拨号音
    AudioServicesRemoveSystemSoundCompletion(DIALING_SOUND_ID);
    AudioServicesDisposeSystemSoundID(DIALING_SOUND_ID);
    [self removeNotifications];
}
-(void) registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intoSession:) name:PRESENT_INSESSION_VIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionClosed:) name:END_SESSION_NOTIFICATION object:nil];
}
-(void) removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//循环播放声音
void soundPlayCallback(SystemSoundID soundId, void *clientData){
    if (soundCount>9) {
        AudioServicesRemoveSystemSoundCompletion(DIALING_SOUND_ID);
        AudioServicesDisposeSystemSoundID(DIALING_SOUND_ID);
    }
    soundCount++;
    AudioServicesPlaySystemSound(DIALING_SOUND_ID);
}

- (void) sessionClosed:(NSNotification*) notify{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HANDLER
- (void)intoSession:(NSNotification*) notify{
    self.inSessionNotify = notify;
    [self performSegueWithIdentifier:@"sessionRequestAcceptedByPeerSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sessionRequestAcceptedByPeerSegue"]) {
        IMInSessionViewController* insessionController = (IMInSessionViewController*)segue.destinationViewController;
        IMCallingViewController* target = (IMCallingViewController*) sender;
        insessionController.manager = target.manager;
        insessionController.inSessionNotify = target.inSessionNotify;
    }
}
@end
