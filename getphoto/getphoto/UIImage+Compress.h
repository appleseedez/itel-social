//
//  UIImage+Compress.h
//  getphoto
//
//  Created by nsc on 13-11-10.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)
- (UIImage *)compressedImage;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
