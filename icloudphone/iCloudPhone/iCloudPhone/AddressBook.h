//
//  AddressBook.h
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol AddressBookDelegate <NSObject>

-(void)addressBookLoadingFinish:(NSArray*)addressBook;

@end
@interface AddressBook : NSObject
@property (nonatomic,weak) id <AddressBookDelegate> delegate;

-(void)loadAddressBook;
@end
