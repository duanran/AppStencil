//
//  BaseRequest.m
//  AppStencil
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "AFHTTPSessionManager.h"


@implementation BaseRequest
- (void)initWithSuccessCallback:(SuccessCallback)success FailCallback:(FailCallback)fail{
    _succeed = success;
    _failed = fail;
}
- (void)requestStart{
    
    NSString *methodStyle = [self getMethod];
    if ([methodStyle isEqualToString:@"GET"]) {
        [self onGet];
    }
    else{
        
    }
}
- (NSString *)getMethod
{
    return @"GET";
}
- (NSString *)getURL
{
    return nil;
}
-(void)setParameter:(NSDictionary *)parameter
{
    self.parameter = parameter;
}
- (void)onGet {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseAdress,[self getURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:url parameters:_parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self processResponse:responseObject];
        _succeed(self);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self processResponseWithError:error];
        _failed(self);
    }];
}
-(void)onPost {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseAdress,[self getURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:_parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self processResponse:responseObject];
        _succeed(self);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self processResponseWithError:error];
        _failed(self);
        
    }];
}
- (void)processResponse:(NSDictionary *)res{
    if (res) {
        NSInteger statusCode = [res[@"statusCode"]integerValue];
        _response = [[ResponseObject alloc]init];
        _response.statusCode = statusCode;
        _response.resData = res[@""];
    }

}
- (void)processResponseWithError:(NSError *)err{
        _response = [[ResponseObject alloc]init];
        _response.statusCode = -1;
        _response.errorMessgae = err.description;
}




@end
