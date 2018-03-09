//
//  BaseRequest.h
//  AppStencil
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "ResponseObject.h"
static NSString * _Nullable baseAdress = @"www.baidu.com";

@interface BaseRequest : NSObject
typedef void(^SuccessCallback)(BaseRequest * _Nullable request);
typedef void(^FailCallback)(BaseRequest * _Nullable requset);

@property(nonatomic,copy,nullable)SuccessCallback succeed;
@property(nonatomic,copy,nullable)FailCallback failed;
@property(nonatomic,copy,nullable)NSDictionary *parameter;

@property(nonatomic,copy)ResponseObject * _Nullable response;


@end
