//
//  ContactCell.h
//  iCloudPhone
//
//  Created by nsc on 13-11-26.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCellTopView.h"
#import "NXImageView.h"
@interface ContactCell : UITableViewCell
@property  (nonatomic,strong) UILabel *lbNickName;
@property  (nonatomic,strong) UILabel *lbAlias;
@property  (nonatomic,strong) UILabel *lbItelNumber;
@property  (nonatomic,strong) NXImageView *imgPhoto;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) ContactCellTopView *topView;
@property (nonatomic) float currenTranslate;
@end
