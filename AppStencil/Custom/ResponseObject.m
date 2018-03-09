//
//  ResponseObject.m
//  AppStencil
//
//  Created by apple on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ResponseObject.h"

@implementation ResponseObject
-(BOOL) isSucceed{
    self.statusCode = 200;
    return YES;
}

@end
