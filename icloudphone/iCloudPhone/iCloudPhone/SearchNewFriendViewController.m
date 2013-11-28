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
@interface SearchNewFriendViewController ()
@property (nonatomic,strong) ItelBook *searchResult;
@end

@implementation SearchNewFriendViewController

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(ItelBook*)searchResult{
    if (_searchResult==nil) {
        _searchResult=[[ItelBook alloc]init];
    }
    return _searchResult;
}
#pragma mark -网络接口


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
#pragma mark -tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.searchResult getAllKeys] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"查询结果";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (StrangerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    StrangerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StrangerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    if ([[self.searchResult getAllKeys] count]>indexPath.row) {
        ItelUser *user=[self.searchResult userAtIndex:indexPath.row];
        cell.imageView.image=[UIImage imageNamed:@"mockhead"];
        cell.lbItelNumber.text=user.itelNum;
     
             cell.lbNickName.text=user.nickName;
        
      
    }
 
    
    //config the cell
    return cell;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResultShow:) name:@"searchStranger" object:nil];
    }
-(void)searchResultShow:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"searchStranger"]) {
        BOOL isNormal=[[notification.userInfo objectForKey:@"isNormal"]boolValue];
        if (isNormal) {
            NSArray *list=[notification.object objectForKey:@"list"];
            if ([list count]) {
                for ( NSDictionary *dic in list) {
                    ItelUser *user=[ItelUser userWithDictionary:dic];
                    if (!user.isFirend) {
                    [self.searchResult addUser:user forKey:user.itelNum];
                    }
                   
                    [self.tableView reloadData];
                }
            }
        }
        else {
            NSLog(@"%@",[notification.userInfo objectForKey:@"reason"]);
        }
    }
}
-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    StrangerViewController *strangerVC=[story instantiateViewControllerWithIdentifier:@"stragerView"];
    strangerVC.user = [self.searchResult userAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:strangerVC animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    NSString *search=searchBar.text;
    
    if ([NXInputChecker checkEmpty:search]) {
        [[ItelAction action] searchStranger:search newSearch:YES];
    }
    
}
@end
