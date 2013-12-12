//
//  SearchNewFriendViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "SearchNewFriendViewController.h"
#import "NXInputChecker.h"
#import "ItelBook.h"
#import "StrangerCell.h"
#import "StrangerViewController.h"
#import "NewFriendListViewController.h"
@interface SearchNewFriendViewController ()
@end

@implementation SearchNewFriendViewController

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -网络接口


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)pushNewFriendList:(NSString*)searchText{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:Nil];
    NewFriendListViewController *newList=[story instantiateViewControllerWithIdentifier:@"newFriendList"];
    newList.searchText=searchText;
    [self.navigationController pushViewController:newList animated:YES];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    NSString *search=searchBar.text;
    
    
    [self pushNewFriendList:search ];
}
@end
