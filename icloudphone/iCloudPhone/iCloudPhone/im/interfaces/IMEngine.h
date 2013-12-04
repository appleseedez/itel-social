//
//  IMEngine.h
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "NatTypeImpl.h"
#import "video_render_ios_view.h"
@protocol IMEngine <NSObject>
//初始化网络
- (void) initNetwork;
//初始化媒体库
- (void) initMedia;
//获取natType
- (NatType) natType;
//获取本机端点地址
- (NSDictionary*)endPointAddressWithProbeServer:(NSString*) probeServerIP port:(NSInteger) probeServerPort;
//获取p2p通道
- (int) tunnelWith:(NSDictionary*) params;
//开始传输
- (BOOL) startTransport;
//终止传输
- (void) stopTransport;
//开启远端视频输入窗口
- (void) openScreen:(VideoRenderIosView*) remoteRenderView;
//关闭远端视频输入窗口
- (void) closeScreen;
- (void) tearDown;
- (void) keepSessionAlive:(NSString*) probeServerIP port:(NSInteger) port;
@end
