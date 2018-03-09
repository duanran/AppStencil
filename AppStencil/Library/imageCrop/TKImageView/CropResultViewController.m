//
//  CropResultViewController.m
//  TKImageViewDemo
//
//  Created by yinyu on 08/01/2017.
//  Copyright © 2017 yinyu. All rights reserved.
//

#import "CropResultViewController.h"
#import "AFNetworking.h"
#import "HudUtil.h"
#import "OCRSDK.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
@interface CropResultViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *cropResultImageView;
@property (retain,nonatomic)NSMutableDictionary *translate;

@end

@implementation CropResultViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"编辑完成";
    self.cropResultImageView.image = _cropResultImage;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}
-(void)youdaoOCR{
    [HudUtil show:self.view text:@"图片识别中..."];
    
    //将图片转为base64编码字符串，然后调用接口查询
    NSString *base64Str = [self image2DataURL:_cropResultImage];
    YDOCRRequest *request = [YDOCRRequest request];
    YDOCRParameter *param = [YDOCRParameter param];
    param.langType = @"zh-en"; //设置识别语言为英文
    param.source = @"youdaoocr"; //设置源
    param.detectType = @"10011"; //设置识别类型，10011位片段识别，目前只支持片段识别
    request.param = param;
    [request lookup:base64Str WithCompletionHandler:^(YDOCRRequest *request, YDOCRResult *result, NSError *error) {
        if (error) {
            //失败
            NSLog(@"error:%@", error);
            [HudUtil show:self.view text:@"识别失败"];
        }else {
            //成功
            NSLog(@"%@", result);[HudUtil show:self.view text:@"识别成功"];
            NSLog(@"result=%@",result);
            NSString *resultstr = [self textFromOCRResult:result];
            NSLog(@"resultstr=%@",resultstr);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"识别内容" message:resultstr preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"翻译成中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {                
                NSLog(@"OK Action");
                [self youdaoTranslate:resultstr];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"Cancel Action");
            }];
            
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:^{
                NSLog(@"展示完成");
            }];
//            [self handleOCRReuslt:result];
        }
    }];
    
}
- (NSString *)image2DataURL:(UIImage *)image {
    NSData *imageData = nil;
    
    //注意：1.图片最长宽不能超过768
    if (image.size.width > 768 || image.size.height > 768) {
        CGSize newSize;
        if (image.size.width > image.size.height) {
            newSize = CGSizeMake(768, image.size.height / image.size.width * 768);
        }else {
            newSize = CGSizeMake(image.size.width / image.size.height * 768, 768);
        }
        image = [self imageWithImage:image scaledToSize:newSize];
       self.cropResultImageView.image  = image;
    }
    
    //注意：2.imageData压缩后不能超过1.5MB
    CGFloat imageDataSize = 0, compressionQuality = 0.9;
    do {
        imageData = UIImageJPEGRepresentation(image, compressionQuality);
        imageDataSize = imageData.length / 1024;
        compressionQuality = compressionQuality * 0.5;
    } while (imageDataSize > 1.5 * 1024);
    
    return [imageData base64EncodedStringWithOptions:0];
}
- (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(IBAction)uploadImage:(id)sender{
    [self youdaoOCR];
//    if (_cropResultImage) {
//        NSData *imageDate = UIImageJPEGRepresentation(_cropResultImage, 0.001);
//        NSString *imageString = [[NSString alloc]init];
//        imageString = [imageDate base64EncodedStringWithOptions:0];
//
//
//
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        NSString *baseUrl = @"http://172.16.40.252:9999/imageUpload";
////        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
//
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//
//
//        NSDictionary *body = @{@"img" : imageString};
//        [manager POST:baseUrl parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"提交成功");
//
//           id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//
//            if (jsonData) {
//                NSString *mess = jsonData[@"words"];
//                mess = [mess stringByTrimmingCharactersInSet:[NSMutableCharacterSet whitespaceCharacterSet]];
//                NSLog(@"message=%@",mess);
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"识别内容" message:mess preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    NSLog(@"OK Action");
//                }];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    NSLog(@"Cancel Action");
//                }];
//
//                [alert addAction:okAction];
//                [alert addAction:cancelAction];
//
//                [self presentViewController:alert animated:YES completion:^{
//                    NSLog(@"展示完成");
//                }];
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"error=%@",error);
//        }];
//
//    }
    
}
- (IBAction)clickCloseBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated: YES];
    
}
- (NSString *)textFromOCRResult:(YDOCRResult *)result {
    NSString *resStr = @"";
    if (result) {
        for (YDOCRRegion *region in result.regions) {
            for (YDOCRLine *line in region.lines) {
                for (YDOCRWord *word in line.words) {
                    resStr = [resStr stringByAppendingString:[NSString stringWithFormat:@"%@ ", word.text]];
                }
                resStr = [resStr stringByAppendingString:@"\n\n"];
            }
            resStr = [resStr stringByAppendingString:@"\n\n\n"];
        }
    }
    return resStr;
}

#pragma mark-有道翻译api
-(void)youdaoTranslate:(NSString *)sourceStr{
    NSLog(@"sourceStr=%@",sourceStr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"http://openapi.youdao.com/api";
//    sourceStr = @"you are boy?";
//    NSString *encodeStr = [sourceStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodeStr = [self urlEncodeing:sourceStr];
    NSString *appkey = @"0f51f515d64e909d";
    NSString *salt = [NSString stringWithFormat:@"%d",[self getRandomNumber:1 to:100000]];
    
    NSString *sign = [self createSign:sourceStr Salt:salt];
    NSLog(@"sign=%@",sign);
    NSDictionary *parameter = @{
                                @"q" : encodeStr,
                                @"from" : [self urlEncodeing:@"auto"],
                                @"to" : [self urlEncodeing:@"zh-CHS"],
                                @"appKey" :[self urlEncodeing:appkey],
                                @"salt": [self urlEncodeing:salt],
                                @"sign" : [self urlEncodeing:sign],
                                };
    
    
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *errorCode = responseObject[@"errorCode"];
        if ([errorCode isEqualToString:@"0"]) {
            NSArray *tanslationArr = responseObject[@"translation"];
            NSString *result = @"翻译内容:";
            NSLog(@"tanslationArr=%@",tanslationArr);
            for (int i = 0; i < tanslationArr.count; i++) {
                NSString *str = tanslationArr[i];
                NSLog(@"str=%@",str);
                result = [result stringByAppendingString:str];
                
            }

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:result preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK Action");
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                NSLog(@"翻译完成");
            }];
        
            
        }
        else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
    }];
}
//
    
-(NSString *)urlEncodeing:(NSString *)sourceStr{
        NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [sourceStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
}


-(NSString *)createSign:(NSString *)qStr Salt:(NSString *)salt{
   
    NSString *appkey = @"0f51f515d64e909d";
    NSString *secretkey = @"3ClPA05xAUA3RCRS57Ie0hMQtz4c4iJr";
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",appkey,qStr,salt,secretkey];
    NSString *md5Vaule = [self makeMd5:sign];
    return md5Vaule;
}
-(int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from + 1)));
}
- (NSString *)makeMd5:(NSString *)source{
    const char *str = [source UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5 = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15]]; // [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]
    //    DLOG(@"path ext %@", [key pathExtension]);
    
   NSString *upper = [md5 uppercaseString];
    
    return upper;
}
NSString *cachedFileNameForKey(NSString *key) {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15]]; // [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]
    //    DLOG(@"path ext %@", [key pathExtension]);
    
    return filename;
}
@end
