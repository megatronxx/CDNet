//
//  UIFont+Scale.m
//  ZGHMS
//
//  Created by HaiLai on 15/11/18.
//  Copyright © 2015年 海莱. All rights reserved.
//

#import "UIFont+Scale.h"

@implementation UIFont (Scale)
+(UIFont *)systemFontOfSize:(CGFloat)fontSize withScale:(CGFloat)scale
{
    return [UIFont systemFontOfSize:fontSize * scale];
}
+(UIFont*)boldSystemFontOfSize:(CGFloat)fontSize withScale:(CGFloat)scale
{
    return [UIFont boldSystemFontOfSize:fontSize*scale];
}
@end
