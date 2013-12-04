//
//  IMManager.h
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantHeader.h"
#import "video_render_ios_view.h"
@protocol IMManager <NSObject>
- (NSString*) myAccount;
//拨号
- (void) dial:(NSString*) account;
// 开始通话过程
- (void) startSession:(NSString*) destAccount;
// 结束通话过程
- (void) endSession;
// 初始化&启动
- (void) setup;
// 连接服务器
- (void) connectToSignalServer;
// 断开连接
-(void) disconnectToSignalServer;
//销毁
- (void) tearDown;
//接受通话请求
- (void) acceptSession:(NSNotification*) notify;
// 终止通话请求
- (void)haltSession:(NSDictionary*) data;
- (void) lockScreenForSession;
- (void) unlockScreenForSession;
//设置视频输出窗口
- (void) openScreen:(VideoRenderIosView*) remoteRenderView;
//关闭视频窗口
- (void) closeScreen;
@end
