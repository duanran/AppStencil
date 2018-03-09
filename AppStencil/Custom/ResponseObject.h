//
//  ResponseObject.h
//  AppStencil
//
//  Created by apple on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseObject : NSObject
@property(nonatomic,assign)NSInteger statusCode;
@property(nonatomic,copy)NSString *errorMessgae;
@property(nonatomic,copy)id resData;

-(BOOL) isSucceed;

@end
