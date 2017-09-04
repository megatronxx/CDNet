//
//  UIButton+Block.h
//  ZGHMS
//
//  Created by HaiLai on 15/11/19.
//  Copyright © 2015年 海莱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
typedef void (^ActionBlock)();
@interface UIButton (Block)
@property (readonly) NSMutableDictionary *event;
- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;  
@end
