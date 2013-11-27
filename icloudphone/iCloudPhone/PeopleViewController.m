//
//  PeopleViewController.m
//  iCloudPhone
//
//  Created by nsc on 13-11-18.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "PeopleViewController.h"
#import "ItelAction.h"
#import "ItelBook.h"
#import "ContactCell.h"
#import "UserViewController.h"
@interface PeopleViewController ()
@property (nonatomic,strong) ItelBook *contacts;
@property (nonatomic,strong) ItelBook *searchResult;
@end
static int start =0;
static BOOL isEnd=0;
@implementation PeopleViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.searchResult=self.contacts;
    
}
-(ItelBook*)searchResult{
    if (_searchResult==nil) {
        _searchResult=[[ItelBook alloc]init];
        
    }
    return _searchResult;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"开始搜索:%@",searchBar.text );
    [self search:searchBar.text];
    [self.view endEditing:YES];
}
-(void)search:(NSString*)text{
    NSUInteger length=[text length];
       ItelBook *search=[[ItelBook alloc]init];
    for (NSString *itel in [self.contacts getAllKeys]) {
        ItelUser *user=[self.contacts userForKey:itel];
        NSString *nickname=user.nickName;
     
        if ([user.nickName length]>=length) {
            NSString *nick=[nickname substringWithRange:NSMakeRange(0, length)];
            if ([text isEqualToString:nick]) {
                [search addUser:user forKey:itel];
            }
        }
        if ([user.itelNum length]>=length) {
            NSString *uitel=[user.itelNum substringWithRange:NSMakeRange(0, length)];
            if ([text isEqualToString:uitel]) {
                [search addUser:user forKey:itel];
            }
        }
    
    }
    self.searchResult=search;
    [self.tableVIew reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.searchResult getAllKeys] count];

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (ContactCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    if ([[self.searchResult getAllKeys] count]>indexPath.row) {
        ItelUser *user=[self.searchResult userAtIndex:indexPath.row];
        
        cell.imageView.image=[UIImage imageNamed:@"头像.jpg"];
        cell.lbAlias.text=user.remarkName;
        cell.lbNickName.text=user.nickName;
    }
   
    //config the cell
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    ItelUser *user=[self.contacts userAtIndex:indexPath.row];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    UserViewController *userVC=[storyBoard instantiateViewControllerWithIdentifier:@"userView"];
    userVC.user=user;
    [self.navigationController pushViewController:userVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//   dispatch_queue_t getFriend= dispatch_queue_create("getFriend", NULL);
//    dispatch_async(getFriend, ^{
//            });
    [[ItelAction action] getItelFriendList:0];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriendListNotification:) name:@"getItelList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAliasChanged:) name:@"resetAlias" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delNotification:) name:@"delItelUser" object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableVIew reloadData];
}
-(void)delNotification:(NSNotification*)notification{
    NSDictionary *userInfo=notification.userInfo;
    BOOL isNormal=[[userInfo objectForKey:@"isNormal"] boolValue];
    if (isNormal) {
        self.contacts = [[ItelAction action]getFriendBook];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableVIew reloadData];
        });
        
    }
    
}
-(void)refreshFriendListNotification:(NSNotification*)notification{
    NSDictionary *userInfo=notification.userInfo;
    BOOL isNormal=[[userInfo objectForKey:@"isNormal"] boolValue];
    if (isNormal) {
        self.contacts = [[ItelAction action]getFriendBook];
        self.searchResult=self.contacts;
        //NSLog(@"%@",self.contacts);
        [self.tableVIew reloadData];
    }
    else {
        NSLog(@"获得联系人列表失败");
    }
}
-(void)userAliasChanged:(NSNotification*)notification{
    ItelUser *user=(ItelUser*)notification.object;
    [self.contacts addUser:user forKey:user.itelNum];
    
}
@end
