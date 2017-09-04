/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "UIViewController+HUD.h"
#import <objc/runtime.h>
#import "WFHead.h"

static const NSInteger tipTag = 10233;
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

-(void)deleteTip
{
    [UIView animateWithDuration:0.3 animations:^{
        __weak __block UILabel *_validateTypeLB = [self getTipContainer];
        _validateTypeLB.frame = WFCGRectMake(0, -20, 320, 20);
    }];
}
-(UILabel *)getTipContainer
{
    UILabel *_validateTypeLB = [self.view viewWithTag:tipTag];
    if (!_validateTypeLB) {
        _validateTypeLB = [[UILabel alloc]init];
        _validateTypeLB.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        _validateTypeLB.frame = WFCGRectMake(0, -15, 320, 20);
        _validateTypeLB.textColor = RGBACOLOR(208, 48, 72, 1);
        _validateTypeLB.font = [UIFont systemFontOfSize:11 withScale:autoSizeScaleX];
        _validateTypeLB.textAlignment = NSTextAlignmentCenter;
        _validateTypeLB.tag = tipTag;
        [self.view addSubview:_validateTypeLB];
    }
    return _validateTypeLB;
}
///导航条下的小提示
-(void)showNavgationTip:(NSString *)tip
{
    UILabel *_validateTypeLB = [self getTipContainer];
    _validateTypeLB.text = tip;
    
    [UIView animateWithDuration:0.3 animations:^{
        _validateTypeLB.frame = WFCGRectMake(0, 0, 320, 15);
    }];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(deleteTip) userInfo:nil repeats:NO];
}
-(void)showNavgationTip:(NSString *)tip isWait:(BOOL)iswait
{
    UILabel *_validateTypeLB = [self getTipContainer];
    _validateTypeLB.text = tip;
    
    [UIView animateWithDuration:0.3 animations:^{
        _validateTypeLB.frame = WFCGRectMake(0, 0, 320, 20);
    }];
}

//- (MBProgressHUD *)HUD{
//    return objc_getAssociatedObject(self, HttpRequestHUDKey);
//}
//
//- (void)setHUD:(MBProgressHUD *)HUD{
//    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint
{
//    view = [[[UIApplication sharedApplication]delegate]window];
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
//    HUD.labelText = hint;
//    [view addSubview:HUD];
//    HUD.removeFromSuperViewOnHide = YES;
//    [HUD show:YES];
//    [self setHUD:HUD];
    
    [[ProgressHUDManager shareInterface]showHUDWithText:hint andView:view];
}

//如iswait 有一个旋转菊花
- (void)showHudInView:(UIView *)view hint:(NSString *)hint isWait:(BOOL)iswait
{
//    view = [[[UIApplication sharedApplication]delegate]window];
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
//    HUD.labelText = hint;
//    [view addSubview:HUD];
//    if(iswait)
//    {
//        HUD.mode = MBProgressHUDModeIndeterminate;
//    }
//    HUD.removeFromSuperViewOnHide = YES;
//    [HUD show:YES];
//    [self setHUD:HUD];
    [[ProgressHUDManager shareInterface]showHUDWithText:hint isWait:iswait andView:view];
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint waited:(BOOL)iswait
{
//    view = [[[UIApplication sharedApplication]delegate]window];
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
//    HUD.labelText = hint;
//    [view addSubview:HUD];
//    if(iswait)
//    {
//        HUD.mode = MBProgressHUDModeIndeterminate;
//    }
//    HUD.removeFromSuperViewOnHide = YES;
//    [HUD show:YES];
//    [self setHUD:HUD];
    [[ProgressHUDManager shareInterface]showHUDWithText:hint isWait:iswait andView:view];
}

- (void)hideHud
{
//    MBProgressHUD *hud = [self HUD];
    //NSLog(@"lp aa hud:%@",hud);
//    [[self HUD] hide:YES];
    [[ProgressHUDManager shareInterface]hideHUD];
}

///错误信息
-(void)showError:(NSString *)err
{
    if (err) {
        if (err.length > 0) {
            if ([err containsString:@"超时"]) {
                NSLog(@"超时信息");
                return;
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [HWWeakTimer scheduledTimerWithTimeInterval:3.2f block:^(id userInfo) {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            } userInfo:nil repeats:NO];
        }
    }
    
//    UIView *keywindow = [[UIApplication sharedApplication]keyWindow];
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:keywindow animated:YES];
//    HUD.labelText = err;
//    [keywindow addSubview:HUD];
//    HUD.mode = MBProgressHUDModeText;
//    HUD.removeFromSuperViewOnHide = YES;
////    HUD.yOffset = WF_UI_VIEW_HEIGHT / 2 - 60;
//    if ([ProgressHUDManager shareInterface].keyboardIsVisible) {
//        HUD.yOffset = -130;
//    }
//    [HUD show:YES];
//    HUD.margin = 10.0f;
//    [HUD hide:YES afterDelay:2];
}

#pragma mark - 定时
- (void)showHint:(NSString *)hint {
    
    //显示提示信息
    UIView *view = self.view;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = hint;
//    hud.margin = 10.f;
////    hud.yOffset = WF_ISIPHONE5?200.f:150.f - 150;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:2];
    NSString *str = hint ?: @"";
    [[ProgressHUDManager shareInterface]showHUDWithText:str andView:view];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = self.view;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = hint;
//    hud.margin = 10.f;
////    hud.yOffset = WF_ISIPHONE5?200.f:150.f;
////    hud.yOffset += yOffset;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:2];
    NSString *str = hint ?: @"";
    [[ProgressHUDManager shareInterface]showHUDWithText:str andView:view];
}
- (void)showHint:(NSString *)hint withDelay:(NSTimeInterval)delay
{
    //显示提示信息
    UIView *view = self.view;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = hint;
//    hud.margin = 10.f;
//    //    hud.yOffset = WF_ISIPHONE5?200.f:150.f;
//    //    hud.yOffset += yOffset;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:delay];
    NSString *str = hint ?: @"";
    [[ProgressHUDManager shareInterface]showHUDWithText:str withInterval:delay andView:view];
}
@end
