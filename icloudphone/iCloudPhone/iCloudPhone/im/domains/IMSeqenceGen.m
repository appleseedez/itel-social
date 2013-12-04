//
//  IMSeqenceGen.m
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMSeqenceGen.h"
static NSUInteger _seq;
@implementation IMSeqenceGen
+(NSUInteger)seq{
    return ++ _seq;
}
@end
