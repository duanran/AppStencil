//
//  HudUtil.m
//  AppStencil
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HudUtil.h"
#import "MBProgressHUD.h"
@implementation HudUtil
+(void)show:(UIView *)view text:(NSString *)text{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.mode = MBProgressHUDModeCustomView;// MBProgressHUDModeText;
    HUD.labelText = text;
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}
@end
