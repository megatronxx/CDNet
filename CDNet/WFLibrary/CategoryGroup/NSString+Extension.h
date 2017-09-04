//
//  NSString+Extension.h
//  ZGHMS
//
//  Created by 海莱 on 15/10/23.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (Extension)
///尺寸计算
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;
///是否是中文
-(BOOL)isChinese;
@end
