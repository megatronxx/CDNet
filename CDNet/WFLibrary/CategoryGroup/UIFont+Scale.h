//
//  UIFont+Scale.h
//  ZGHMS
//
//  Created by HaiLai on 15/11/18.
//  Copyright © 2015年 海莱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Scale)
+(UIFont *)systemFontOfSize:(CGFloat)fontSize withScale:(CGFloat)scale;
+(UIFont*)boldSystemFontOfSize:(CGFloat)fontSize withScale:(CGFloat)scale;
@end
