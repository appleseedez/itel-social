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
#import "NXInputChecker.h"
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
-(NSArray*)getAllKeys{
    while (self.isLoading) {
        
    }
   return  [super getAllKeys];
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
                self.isLoading=YES;
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
        
        NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(person), kABPersonFirstNameProperty));
        firstName = [firstName stringByAppendingFormat:@" "];
        NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(person), kABPersonLastNameProperty));
        if (lastName==nil) {
            lastName=@"";
        }
        NSString *fullName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        //NSLog(@"%@",fullName);
        
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(CFBridgingRetain(person), kABPersonPhoneProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
        {
            
            NSString *phone = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
            
            
            NSString *mobilePhone=[NXInputChecker resetPhoneNumber11:phone];
            if ([NXInputChecker checkPhoneNumberIsMobile:mobilePhone]) {
                PersonInAddressBook *p=[[PersonInAddressBook alloc] init];
                p.name=fullName;
                p.tel=mobilePhone;
                [self addUser:p forKey:p.tel];
               // NSLog(@"%@:%@",p.name,p.tel);
            }
            
        }
        
        
        
        
    }
    
    self.isLoading=NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
         [[NSNotificationCenter defaultCenter] postNotificationName:@"addressLoadingFinish" object:self];
    });
   
    
}
@end
