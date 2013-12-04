//
//  IMDataPool.h
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMDataPool : NSObject
- (void) addData:(id) data
          forKey:(NSString*)key;
@end
