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
@property (nonatomic,strong)NSMutableOrderedSet *addedItels;
@end

@implementation ItelBookManager
#define PATH [NSHomeDirectory() stringByAppendingString:@"/users/"]
+(ItelBookManager*)defaultManager{
    
    if (manager==nil) {
        manager=[[ItelBookManager alloc]init];
        
    }
    
    return manager;
}
#pragma mark - 添加用户到等待确认列表
-(void)addItelUserIntoAddedList:(NSString *)itel{
    
    
        [self.addedItels addObject:itel];
        [self saveAddedItels];
        NSLog(@"%@",self.addedItels);
   
    
}
#pragma mark - 删除用户从等待确认列表
-(void)delItelUserIntoAddedList:(NSString *)itel{
    [self.addedItels removeObject:itel];
    [self saveAddedItels];
    NSLog(@"%@",self.addedItels);
    
    
}
-(NSMutableOrderedSet*)addedItels{
    if (_addedItels==nil) {
       NSString *hostNum = [[ItelAction action] getHost].itelNum;
        NSString *path=[PATH stringByAppendingString:hostNum];
        _addedItels=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (_addedItels==nil) {
            _addedItels=[[NSMutableOrderedSet alloc]init];
        }
    }
    return _addedItels;
}
-(BOOL)checkItelInAddedList:(NSString*)itel{
    for (NSString *added in self.addedItels) {
        if ([itel isEqualToString:added]) {
            return YES;
        }
    }
    return NO;
}
-(void)saveAddedItels{
    NSString *hostNum = [[ItelAction action] getHost].itelNum;
    NSString *path=[PATH stringByAppendingString:hostNum];
    [NSKeyedArchiver archiveRootObject:self.addedItels toFile:path];
    
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
//    for (NSDictionary *dic in itelUsers) {
//        ItelUser *user=[ItelUser userWithDictionary:dic];
//        [[ItelAction action] inviteItelUserFriend:user.itelNum];
//        
//    }
    
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
