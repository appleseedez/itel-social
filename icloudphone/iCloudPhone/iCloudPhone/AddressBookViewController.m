//
//  AddressBookViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-17.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "AddressBookViewController.h"
#import "PersonInAddressBook.h"
#import  "AddressBookCell.h"
@interface AddressBookViewController ()
@property (nonatomic,strong) NSArray *addressBook;

@end

@implementation AddressBookViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    AddressBook *book=[[AddressBook alloc]init];
    book.delegate = self;
    [book loadAddressBook];
	// Do any additional setup after loading the view.
}
#pragma mark -addressbookDelegate
-(void)addressBookLoadingFinish:(NSArray*)addressBook{
    self.addressBook=addressBook;
    [self.tableView reloadData];
}

#pragma mark -tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%d",[self.addressBook count]);
    return [self.addressBook count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"我的通讯录";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    if ([self.addressBook count]-1>=indexPath.row) {
        PersonInAddressBook *person=[self.addressBook objectAtIndex:indexPath.row];
        [cell setCell:person];
    }
    
    
        //config the cell
    return cell;
    
}


@end
