//
//  ItelBook.h
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItelAction.h"
@interface ItelBook : NSObject <NSCopying>
-(void)addUser:(ItelUser*)user forKey:(NSString*)key;
-(void)removeUserforKey:(NSString*)key;
-(NSArray*)getAllKeys;
-(ItelUser*)userForKey:(NSString*)key;
-(ItelUser*)userAtIndex:(NSInteger)index;
-(ItelBook*)appendingByItelBook:(ItelBook*)itelBook;
@end
