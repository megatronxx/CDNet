//
//  ProgressHUDManager.h
//  ZGHMS
//
//  Created by HaiLai on 15/11/7.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressHUDManager : NSObject
@property (nonatomic,assign) BOOL keyboardIsVisible;
+(ProgressHUDManager *)shareInterface;
-(void)showHUDWithText:(NSString *)text andView:(UIView *)view;
-(void)showHUDWithText:(NSString *)text isWait:(BOOL)isWait andView:(UIView *)view;
-(void)showHUDWithText:(NSString *)text withInterval:(NSTimeInterval)interval andView:(UIView *)view;
-(void)hideHUD;
@end
