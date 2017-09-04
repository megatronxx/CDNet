//
//  UIView+DDHUD.m
//  Dingding2
//
//  Created by lipeng on 15/6/4.
//  Copyright (c) 2015年 lipeng. All rights reserved.
//

#import "UIView+DDHUD.h"
#import "MBProgressHUDGroup.h"
#import "WFHead.h"
#import <objc/runtime.h>

static const void *viewRequestHUDKey = &viewRequestHUDKey;


@implementation BlackBack

+(instancetype)shareInterface
{
    static BlackBack *interface;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!interface) {
            interface = [[BlackBack alloc]init];
        }
    });
    return interface;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self setFrame:[[UIScreen mainScreen]bounds]];
        UIColor *color = [UIColor blackColor];
        [self setBackgroundColor:[color colorWithAlphaComponent:0.5]];
    }
    return self;
}

-(void)showBlackBack
{
    [[[UIApplication sharedApplication] keyWindow]addSubview:self];
}
-(void)hideBlackBack
{
    [self removeFromSuperview];
}

@end

@implementation UIView (DDHUD)

//- (MBProgressHUD *)HUD{
//    return objc_getAssociatedObject(self, viewRequestHUDKey);
//}
//
//- (void)setHUD:(MBProgressHUD *)HUD{
//    objc_setAssociatedObject(self, viewRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint waited:(BOOL)waited
{
    [[ProgressHUDManager shareInterface]showHUDWithText:hint isWait:waited andView:view];
}

- (void)hideHud
{
    [[ProgressHUDManager shareInterface]hideHUD];
}

///错误信息
-(void)showError:(NSString *)err
{
    if (err.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [HWWeakTimer scheduledTimerWithTimeInterval:3.2f block:^(id userInfo) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        } userInfo:nil repeats:NO];
    }
}

///信息
-(void)showMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [HWWeakTimer scheduledTimerWithTimeInterval:3.2f block:^(id userInfo) {
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    } userInfo:nil repeats:NO];
}

#pragma mark - 定时
- (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication] keyWindow];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = hint;
//    hud.margin = 10.f;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:2];
    [[ProgressHUDManager shareInterface]showHUDWithText:hint andView:view];
}

- (void)showHint:(NSString *)hint withDelay:(NSTimeInterval)interval
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication] keyWindow];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = hint;
//    hud.margin = 10.f;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:interval];
    [[ProgressHUDManager shareInterface]showHUDWithText:hint withInterval:interval andView:view];
}
@end
