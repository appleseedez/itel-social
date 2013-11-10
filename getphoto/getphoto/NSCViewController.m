//
//  NSCViewController.m
//  getphoto
//
//  Created by nsc on 13-11-10.
//  Copyright (c) 2013年 nsc. All rights reserved.
//

#import "NSCViewController.h"

@interface NSCViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation NSCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getPhotoLib:(UIButton *)sender {
}


- (IBAction)getCamera:(UIButton *)sender {
    if (![UIImagePickerController isCameraDeviceAvailable: (UIImagePickerControllerCameraDeviceRear|
        UIImagePickerControllerCameraDeviceFront)]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"相机不可用" message:@"该设备相机不可用" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alert show];
    }
    else {
        UIImagePickerController *pick=[[UIImagePickerController  alloc]init];
        pick.delegate=self;
        pick.allowsEditing=YES;
        [pick setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:pick animated:YES completion:^{
            
        }];
    }
    
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    self.photo.image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
     [picker dismissViewControllerAnimated:YES completion:^{
         
     }];
}
@end
