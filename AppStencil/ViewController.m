//
//  ViewController.m
//  AppStencil
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "CropImageViewController.h"
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"1111");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"具体内容" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        NSLog(@"展示完成");
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
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


@end
