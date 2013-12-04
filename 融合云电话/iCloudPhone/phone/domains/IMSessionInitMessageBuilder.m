//
//  IMSessionInitMessageBuilder.m
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMSessionInitMessageBuilder.h"
#import "ConstantHeader.h"
#import "IMSeqenceGen.h"
@interface IMSessionInitMessageBuilder()

@end
@implementation IMSessionInitMessageBuilder
// IMMessageBuilder接口

- (NSDictionary*)buildWithParams:(NSDictionary *)params{
    return @{
             HEAD_SECTION_KEY:@{
                     DATA_TYPE_KEY: [NSNumber numberWithInt:SESSION_INIT_REQ_TYPE],
                     DATA_STATUS_KEY:[NSNumber numberWithInt:NORMAL_STATUS],
                     DATA_SEQ_KEY:[NSNumber numberWithInteger:[IMSeqenceGen seq]]
                     },
             BODY_SECTION_KEY:params
             
             };
}
@end
