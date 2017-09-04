//
//  ProgressHUDManager.m
//  ZGHMS
//
//  Created by HaiLai on 15/11/7.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import "ProgressHUDManager.h"
#import "WFHead.h"

@interface ProgressHUDManager ()
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation ProgressHUDManager
@synthesize hud,keyboardIsVisible;
+(ProgressHUDManager *)shareInterface
{
    static ProgressHUDManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[ProgressHUDManager alloc]init];
        }
    });
    return manager;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(instancetype)init
{
    if (self = [super init]) {
        keyboardIsVisible = NO;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardWillShowNotification  object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}
- (void)keyboardDidShow
{
    keyboardIsVisible = YES;
}

- (void)keyboardDidHide
{
    keyboardIsVisible = NO;
}

-(void)setHUD:(MBProgressHUD *)huds
{
    if (hud) {
        [hud hide:YES];
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = huds;
}

-(void)showHUDWithText:(NSString *)text andView:(UIView *)view
{
    if (text.length > 0) {
        if (!view) {
            view = [[UIApplication sharedApplication] keyWindow];
        }
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.labelText = text;
        [view addSubview:HUD];
        HUD.mode = MBProgressHUDModeText;
        HUD.removeFromSuperViewOnHide = YES;
        if (keyboardIsVisible) {
            HUD.yOffset = -130;
        }
        [HUD show:YES];
        HUD.margin = 10.0f;
        [HUD hide:YES afterDelay:2];
    }
}
-(void)showHUDWithText:(NSString *)text isWait:(BOOL)isWait andView:(UIView *)view
{
    if (text.length > 0) {
        if (!view) {
            view = [[UIApplication sharedApplication] keyWindow];
        }
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.labelText = text;
        [view addSubview:HUD];
        if(isWait)
        {
            HUD.mode = MBProgressHUDModeIndeterminate;
        }
        HUD.removeFromSuperViewOnHide = YES;
        if (keyboardIsVisible) {
            HUD.yOffset = -130;
        }
        [HUD show:YES];
        [self setHUD:HUD];
    }
}
-(void)showHUDWithText:(NSString *)text withInterval:(NSTimeInterval)interval andView:(UIView *)view
{
    if (text.length > 0) {
        if (!view) {
            view = [[UIApplication sharedApplication] keyWindow];
        }
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.labelText = text;
        [view addSubview:HUD];
        HUD.mode = MBProgressHUDModeText;
        HUD.removeFromSuperViewOnHide = YES;
        HUD.margin = 10.0f;
        if (keyboardIsVisible) {
            HUD.yOffset = -130;
        }
        [HUD show:YES];
        [HUD hide:YES afterDelay:interval];
    }
}
-(void)hideHUD
{
    if (hud) {
        [hud hide:YES];
        hud.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
        [UIView setAnimationDuration:.2f];//动画时间
        hud.transform=CGAffineTransformMakeScale(0.01f, 0.01f);//先让要显示的view最小直至消失
        [UIView commitAnimations]; //启动动画
        [self performSelector:@selector(removeHUdHH) withObject:nil afterDelay:1];

    }else{
        NSLog(@"%s : 无hud",__FUNCTION__);
    }
}
-(void)removeHUdHH
{
    [hud removeFromSuperview];
    hud = nil;
    
}
@end
