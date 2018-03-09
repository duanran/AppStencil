//
//  HomeViewController.m
//  AppStencil
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "CropImageViewController.h"
#import "OCRSDK.h"

@interface HomeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片识别";
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"具体内容" preferredStyle:UIAlertControllerStyleAlert];
//    [self presentViewController:alert animated:YES completion:^{
//        NSLog(@"展示完成");
//    }];
    
    // Do any additional setup after loading the view from its nib.
    //初始化key
    YDTranslateInstance *yd = [YDTranslateInstance sharedInstance];
#warning 填写你所申请到的appkey
    yd.appKey = @"0f51f515d64e909d";
}
#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *toCropImage = info[UIImagePickerControllerOriginalImage];
    [self cropImage: toCropImage];
    [picker dismissViewControllerAnimated: YES completion: NULL];
    
}
- (void)cropImage: (UIImage *)image {
    
    CropImageViewController *cropImageViewController = [[CropImageViewController alloc]initWithNibName:@"CropImageViewController" bundle:nil];
    cropImageViewController.image = image;
    [self.navigationController pushViewController: cropImageViewController animated: YES];
    
}
-(IBAction)carmea:(id)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController: imagePicker animated:YES completion: NULL];
}
-(IBAction)photo:(id)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController: imagePicker animated:YES completion: NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
