//
//  UINavigationBar+Awesome.h
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *          navigationBar lt_setBackgroundColor:
 *          lt_reset
 */
@interface UINavigationBar (Awesome)
///导航条背景色
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
///注意该扩展的原理是给navigationbar加了一个layer，因此为保证合理性，需在willdisappear方法里面删除layer
- (void)lt_reset;
@end
