//
//  IMCommunicator.h
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMCommunicator <NSObject>
//建立链接
- (void) connect;
// 断开链接
- (void) disconnect;
// 发送数据
- (void) send:(NSDictionary*) data;
// 接收数据
- (void) receive:(NSDictionary*) data;

@optional
// 长链接
- (void) keepAlive;

@end
