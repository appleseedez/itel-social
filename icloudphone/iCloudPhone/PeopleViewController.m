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
@property (nonatomic,strong) UIPanGestureRecognizer *gestreRecognizer;
@end
static int start =0;
static BOOL isEnd=0;
@implementation PeopleViewController


static float changelimit=100.0;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gestreRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
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
-(void)panRecognizer:(UIPanGestureRecognizer*)recognizer{
    CGFloat translation=[recognizer translationInView:recognizer.view ].x;
    //NSLog(@"手势滑动：%f",translation);
    //NSLog(@"%f",self.backView.frame.size.height);
    recognizer.maximumNumberOfTouches=1;
    ContactCell *cell=((ContactCellTopView*)recognizer.view).cell;
    if (recognizer.state==UIGestureRecognizerStateChanged) {
        if ((recognizer.view.frame.origin.x>=-changelimit)&&(recognizer.view.frame.origin.x<=changelimit)) {
            
            CGFloat transX=0;
            if (translation>=changelimit) {
                transX=changelimit   ;
            }else if(translation<=-changelimit){
                transX=-changelimit;
            }
            else{
                transX=translation;
            }
            
            [recognizer.view setTransform:CGAffineTransformMakeTranslation( transX-cell.currenTranslate, 0)];
            
            
            //self.topView.frame=CGRectMake(self.topView.frame.origin.x+transX, self.topView.frame.origin.y,  self.topView.frame.size.width , self.topView.frame.size.height);
        }
        
        
        
    }
    else if(recognizer.state==UIGestureRecognizerStateEnded){
        [UIView beginAnimations:@"back" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDelay:0.2];
        recognizer.view.frame=recognizer.view.superview.bounds;
        [UIView commitAnimations];
        if (translation>changelimit) {
            NSLog(@"打电话");
            self.gestreRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
            cell.currenTranslate=cell.currenTranslate-changelimit;
        }
        else if (translation<-changelimit){
            NSLog(@"发短信");
            translation=0;
            cell.currenTranslate=cell.currenTranslate+changelimit;
        }
        
    }
    
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"开始搜索:%@",searchBar.text );
    [self search:searchBar.text];
    [self.view endEditing:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    searchBar.text=nil;
    [self endSearch];
}
-(void)endSearch{
    self.searchResult=self.contacts;
    [self.tableVIew reloadData];
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
    return 80;
}
- (ContactCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    if ([[self.searchResult getAllKeys] count]>indexPath.row) {
        ItelUser *user=[self.searchResult userAtIndex:indexPath.row];
        cell.backView.frame=cell.bounds;
        cell.topView.frame=cell.bounds;
        cell.imageView.image=[UIImage imageNamed:@"头像.jpg"];
        cell.lbAlias.text=user.remarkName;
        cell.lbNickName.text=user.nickName;
    }
   
    //config the cell
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell=(ContactCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.topView removeGestureRecognizer:self.gestreRecognizer];
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCell *cell=(ContactCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.topView addGestureRecognizer:self.gestreRecognizer];
    
    ItelUser *user=[self.searchResult userAtIndex:indexPath.row];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"iCloudPhone" bundle:nil];
    UserViewController *userVC=[storyBoard instantiateViewControllerWithIdentifier:@"userView"];
    userVC.user=user;
    [self.navigationController pushViewController:userVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
