//
//  ItelBookManager.m
//  iCloudPhone
//
//  Created by nsc on 13-11-16.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "ItelBookManager.h"
#import "AddressBook.h"
static ItelBookManager *manager;
@interface ItelBookManager()
@property  (nonatomic,strong)ItelBook *friendBook; //itel好友列表
@property  (nonatomic,strong)ItelBook *blackBook;  //itel黑名单列表
@property  (nonatomic,strong)AddressBook *phoneBook;  //电话联系人列表
@property  (nonatomic,strong)ItelBook *phoneBookItel; //电话联系人中有itel的用户列表
@property  (nonatomic,strong)ItelBook *phoneBookNoneItel; //电话联系人中没有itel用户的列表
@end
@implementation ItelBookManager
+(ItelBookManager*)defaultManager{
    
    if (manager==nil) {
        manager=[[ItelBookManager alloc]init];
    }
    
    return manager;
}
-(ItelBook*)blackBook{
    if (_blackBook==nil) {
        _blackBook=[[ItelBook alloc] init];
        
    }
    return _blackBook;
}
-(ItelBook*)friendBook{
    if (_friendBook==nil) {
        _friendBook = [[ItelBook alloc] init];
    }
    return _friendBook;
}
-(AddressBook*)phoneBook{
    if (_phoneBook==nil) {
        _phoneBook = [[AddressBook alloc]init];
        [_phoneBook loadAddressBook];
    }
    return _phoneBook;
}
-(ItelBook*)phoneBookItel{
    if (_phoneBookItel==nil) {
        _phoneBookItel=[[ItelBook alloc]init];
    }
    return _phoneBookItel;
}
-(ItelBook*)phoneBookNoneItel{
    if (_phoneBookNoneItel==nil) {
        _phoneBookNoneItel =[[ItelBook alloc]init];
    }
    return _phoneBookItel;
}
#pragma mark - 获得本机通讯录电话

-(NSArray*)getAddressPhoneNumbers{
    
    return  [self.phoneBook getAllKeys];
}
#pragma mark - 获得了通讯录中有itel号码的后续操作
/* 1 dic 转化为user
   2 已有itel的user 添加到phoneBookItel
   3 没有itel的user 添加到phoneBookNoneItel
 
 */
-(void)actionWithItelUserInAddressBook:(NSArray*)itelUsers{
    self.phoneBookNoneItel=[self.phoneBook copy];
    for (NSDictionary *dic in itelUsers) {
        ItelUser *user=[ItelUser userWithDictionary:dic];
        [[ItelAction action] inviteItelUserFriend:user.itelNum];
        
    }
    
}
#pragma mark - 获得通讯录
-(void)getAddressBook{
    if (_phoneBook==nil) {
        [self phoneBook];
    }
    else [[NSNotificationCenter defaultCenter] postNotificationName:@"addressLoadingFinish" object:self.phoneBook];
}
#pragma mark - 黑名单
//添加黑名单
-(void)addUserToBlackBook:(NSString*)itel{
    ItelUser *user=[[ItelUser alloc]init];
    user.isBlack=YES;
    user.itelNum=itel;
    [self.blackBook addUser:user forKey:itel];
}
//从黑名单移除
-(void)removeUserFromBlackBook:(NSString*)itel{
    [self.blackBook removeUserforKey:itel];
}
-(void)delUserFromFriendBook:(NSString*)itel{
    [self.friendBook removeUserforKey:itel];
}
#pragma mark - 重新设置备注
-(void)resetUserInFriendBook:(ItelUser*)user{
    
        [self.friendBook addUser:user forKey:user.itelNum];
    
    
}
-(void)resetUserInBlackBook:(ItelUser*)user{
    [self.blackBook addUser:user forKey:user.itelNum];
}
@end
