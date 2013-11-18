//
//  SearchNewFriendViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "SearchNewFriendViewController.h"

@interface SearchNewFriendViewController ()

@end

@implementation SearchNewFriendViewController

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark -网络接口
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    ItelNetManager *manager=[ItelNetManager defaultManager];
    manager.searchUserDelegate=self;
    [manager searchUser:searchBar.text];
}
-(void)searchResult:(id)result{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
#pragma mark -tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"查询结果";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.imageView.image=[UIImage imageNamed:@"头像.jpg"];
    cell.textLabel.text = @"姓名：张三";
    //config the cell
    return cell;
    
}

@end
