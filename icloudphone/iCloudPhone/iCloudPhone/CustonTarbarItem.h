//
//  CustonTarbarItem.h
//  iCloudPhone
//
//  Created by nsc on 13-11-28.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustonTarbarItem : UIButton
@property (nonatomic,strong) UIImageView *cusImageView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *selectedImage;
-(void)setLabelFrame:(CGRect)frame;
-(void)setImageViewFrame:(CGRect)frame;
-(void)setLabelTitle:(NSString*)title;
-(void)isSelected:(BOOL)selected;
@end
