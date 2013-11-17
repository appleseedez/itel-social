//
//  AddressBook.m
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "AddressBook.h"
#import <AddressBook/AddressBook.h>
#import "PersonInAddressBook.h"
@interface AddressBook ()
@property (nonatomic,strong) NSMutableArray *addressBook;
@end
@implementation AddressBook

-(void)loadAddressBook{
    [self getAddressBook];
}

-(NSMutableArray*)addressBook{
    if (_addressBook==nil) {
        _addressBook = [[NSMutableArray alloc]init];
     
    }
    return _addressBook;
}
#pragma mark - 电话本操作
-(void)getAddressBook{
    CFErrorRef error=NULL;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &error);
    float version=[[UIDevice currentDevice].systemVersion floatValue];
    if (version>=7.0) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                NSLog(@"%@",error);
            }
            else if(granted){
                [self getPeopleInAddressBook];
            }
            
        });
    }
    else {
        [self getPeopleInAddressBook];
    }
    CFRelease(addressBook);
}
-(void)getPeopleInAddressBook{
    CFErrorRef error=NULL;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &error);
    
    CFArrayRef arrayRef= ABAddressBookCopyArrayOfAllPeople(addressBook)   ;
    NSArray *array=(NSArray*)CFBridgingRelease(arrayRef);
    for (id person in array)
    {
        PersonInAddressBook *p=[[PersonInAddressBook alloc] init];
        NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(person), kABPersonFirstNameProperty));
        firstName = [firstName stringByAppendingFormat:@" "];
        NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(person), kABPersonLastNameProperty));
        if (lastName==NULL) {
            lastName=@"";
        }
        NSString *fullName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        //NSLog(@"===%@",fullName);
        p.name=fullName;
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(CFBridgingRetain(person), kABPersonPhoneProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
        {
            NSString *phone = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
            //NSLog(@"===%@",phone);
            [p.tels addObject:phone];
        }
        ABMultiValueRef mails = (ABMultiValueRef) ABRecordCopyValue(CFBridgingRetain(person), kABPersonEmailProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(mails); i++)
        {
            NSString *mail = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(mails, i));
            //NSLog(@"==%@",mail);
            [p.emails addObject:mail];
        }
        [self.addressBook addObject:p];
        
    }
    
    //NSLog(@"%@",self.addressBook);
    CFRelease(addressBook);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate addressBookLoadingFinish:self.addressBook];
    });
}
@end
