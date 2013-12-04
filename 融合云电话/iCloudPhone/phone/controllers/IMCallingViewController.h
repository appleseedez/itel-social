//
//  IMCallingViewController.h
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMManager.h"
@interface IMCallingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *peerAccountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *PeerAvatarImageView;
- (IBAction)cancelCalling:(UIButton *)sender;
@property(nonatomic,weak) id<IMManager> manager;
@property(nonatomic,strong) NSNotification* callingNotify;
@end
