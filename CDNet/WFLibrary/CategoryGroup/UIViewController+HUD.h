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

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

///导航条下的小提示
-(void)showNavgationTip:(NSString *)tip;
-(void)showNavgationTip:(NSString *)tip isWait:(BOOL)iswait;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;
- (void)showHudInView:(UIView *)view hint:(NSString *)hint isWait:(BOOL)iswait;
- (void)showHudInView:(UIView *)view hint:(NSString *)hint waited:(BOOL)iswait;

- (void)hideHud;

///错误信息
-(void)showError:(NSString *)err;
- (void)showHint:(NSString *)hint;
// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
- (void)showHint:(NSString *)hint withDelay:(NSTimeInterval)delay;

@end
