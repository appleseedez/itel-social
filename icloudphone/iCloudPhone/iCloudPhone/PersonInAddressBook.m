//
//  PersonInAddressBook.m
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "PersonInAddressBook.h"

@implementation PersonInAddressBook
-(NSMutableArray*)tels{
    if (_tels==nil) {
        _tels=[[NSMutableArray alloc]init];
    }
    return _tels;
}
-(NSMutableArray*)emails{
    if (_emails==nil) {
        _emails=[[NSMutableArray alloc]init];
    }
    return _emails;
}
@end
