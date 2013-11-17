//
//  LeftSideBarViewController.m
//  TV
//
//  Created by nsc on 13-10-24.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "LeftSideBarViewController.h"

@interface LeftSideBarViewController ()
@property (nonatomic,strong) NSMutableArray *controllers;
@end

@implementation LeftSideBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)chageContentView:(UIButton *)sender {
    
    UIViewController *changeVC=nil;
    switch (sender.tag) {
        case 10001:
            changeVC=self.searchVC;
            break;
        case 10002:
            changeVC=self.contentVC;
            break;
        case 10003:
            changeVC=self.addVC;
            break;
            
        default:
            break;
    }
    [self.rootControllerDelegate setContentViewController:changeVC];
    [self.rootControllerDelegate moveAnimationWithDirection:SideBarShowDirectionNone duration:0.3];
}


#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"分组1";
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
