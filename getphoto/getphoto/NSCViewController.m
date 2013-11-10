//
//  NSCViewController.m
//  getphoto
//
//  Created by nsc on 13-11-10.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "NSCViewController.h"
#import "UIImage+Compress.h"
#import "UIImageView+BetterFace.h"
@interface NSCViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *originalImage;



@property (weak, nonatomic) IBOutlet UIImageView *betterFaceImage;

@end

@implementation NSCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.editedImage.layer setBorderColor:[UIColor grayColor].CGColor];
//    [self.editedImage.layer setBorderWidth:0.5f];
    [self.betterFaceImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.betterFaceImage setClipsToBounds:YES];
    [self.betterFaceImage setNeedsBetterFace:YES];
    [self.betterFaceImage setFast:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getPhotoLib:(UIButton *)sender {
}


- (IBAction)getCamera:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"相机不可用" message:@"该设备相机不可用" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alert show];
    }
    else {
        UIImagePickerController *pick=[[UIImagePickerController  alloc]init];
        pick.delegate=self;
        pick.allowsEditing=NO;
        [pick setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:pick animated:YES completion:^{
            
        }];
    }
    
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //原始图片
    UIImage *OriginalImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.originalImage.image=OriginalImage;
    
  
    
    
    //压缩质量
    NSData *compressed=UIImageJPEGRepresentation([OriginalImage compressedImage],0.5);
    
    UIImage *compressedImage=[UIImage imageWithData:compressed];
   
    self.betterFaceImage.image=compressedImage;
//    //压缩像素
//    UIImage *compressedPixel =[UIImage imageWithImage:compressedBytesImage scaledToSize:self.betterFaceImage.bounds.size];
//    compressedPixel = [compressedPixel compressedImage];
//    self.compressedPixelImage.image=compressedPixel;
    
    
    
    
    
    
        [self sizeOfImage];
     [picker dismissViewControllerAnimated:YES completion:^{
         
     }];
}
-(void)sizeOfImage{
    NSData *original= UIImagePNGRepresentation(self.originalImage.image);
    NSLog(@"1 原始图片大小：%ldByte",(long)original.length);
    
  
    NSData *face = UIImagePNGRepresentation(self.betterFaceImage.image);
    NSLog(@"2 处理以后图片大小：%ldByte",(long)face.length);
    
   
}
@end
