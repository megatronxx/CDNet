//
//  UIView+DDHUD.h
//  Dingding2
//
//  Created by lipeng on 15/6/4.
//  Copyright (c) 2015年 lipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DDHUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint waited:(BOOL)waited;
- (void)hideHud;
///错误信息
-(void)showError:(NSString *)err;
///信息
-(void)showMessage:(NSString *)msg;
- (void)showHint:(NSString *)hint;
- (void)showHint:(NSString *)hint withDelay:(NSTimeInterval)interval;
@end

@interface BlackBack : UIView
+(instancetype)shareInterface;
-(void)showBlackBack;
-(void)hideBlackBack;
@end