//
//  IMMessageBuilder.h
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol IMMessageBuilder <NSObject>
- (NSDictionary*) buildWithParams:(NSDictionary*) params;
@end
