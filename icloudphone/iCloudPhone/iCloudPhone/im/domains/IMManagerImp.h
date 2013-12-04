//
//  IMManagerImp.h
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMManager.h"
#import "IMEngine.h"
#import "IMEngineImp.h"
#import "IMCommunicator.h"
#import "IMTCPCommunicator.h"
#import "IMMessageBuilder.h"
#import "IMSessionInitMessageBuilder.h"
#import "IMAuthMessageBuilder.h"
#import "IMSessionPeriodRequestMessageBuilder.h"
#import "IMSessionPeriodResponseMessageBuilder.h"
#import "IMSessionRefuseMessageBuilder.h"
#import "IMMessageParser.h"
#import "IMMessageParserImp.h"
#import "IMDataPool.h"
@interface IMManagerImp : NSObject <IMManager>
// 数据暂存
@property (nonatomic) IMDataPool* dataPool;
//sdk引擎
@property (nonatomic) id<IMEngine> engine;
//网络通信器
@property (nonatomic) id<IMCommunicator> communicator;
// 信令构造器
@property (nonatomic) id<IMMessageBuilder> messageBuilder;
// 信令解析器
@property (nonatomic) id<IMMessageParser> messageParser;


@end
