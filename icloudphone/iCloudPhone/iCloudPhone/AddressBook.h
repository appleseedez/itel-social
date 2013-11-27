//
//  AddressBook.h
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItelBook.h"
@protocol AddressBookDelegate <NSObject>

-(void)addressBookLoadingFinish:(NSArray*)addressBook;

@end
@interface AddressBook : ItelBook
@property (nonatomic,weak) id <AddressBookDelegate> delegate;
@property (nonatomic)   BOOL isLoading;
-(void)loadAddressBook;

@end
