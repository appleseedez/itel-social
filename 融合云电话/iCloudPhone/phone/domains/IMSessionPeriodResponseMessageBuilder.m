//
//  IMSessionPeriodResponseMessageBuilder.m
//  im
//
//  Created by Pharaoh on 13-11-22.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMSessionPeriodResponseMessageBuilder.h"
#import "ConstantHeader.h"
#import "IMSeqenceGen.h"
@implementation IMSessionPeriodResponseMessageBuilder
- (NSDictionary *)buildWithParams:(NSDictionary *)params{
    NSError* error;
    NSDictionary* result = @{
                             HEAD_SECTION_KEY:@{
                                     DATA_TYPE_KEY: [NSNumber numberWithInt:SESSION_PERIOD_REQ_TYPE],
                                     DATA_STATUS_KEY:[NSNumber numberWithInt:NORMAL_STATUS],
                                     DATA_SEQ_KEY:[NSNumber numberWithInteger:[IMSeqenceGen seq]]
                                     },
                             BODY_SECTION_KEY:@{
                                     SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY:[params valueForKey:SESSION_INIT_REQ_FIELD_SRC_ACCOUNT_KEY],
                                     DATA_CONTENT_KEY:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:0 error:&error]  encoding:NSUTF8StringEncoding]
                                     
                                     }
                             
                             };
    if (error) {
        [NSException exceptionWithName:@"400:Data Parse Error" reason:@"json数据构造失败" userInfo:nil];
        return @{};
    }
    return result;
}
@end
