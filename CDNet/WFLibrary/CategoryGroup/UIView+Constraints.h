//
//  UIView+Constraints.h
//  AtuolayoutDemo
//
//  Created by 海莱 on 15/9/28.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VDesKey         @"vdeskey"
#define HDesKey         @"hdeskey"
#define ViewDesKey      @"viewdeskey"

@interface UIView (Constraints)
- (void)addSubview:(UIView *)view withDescription:(NSDictionary *)des;
@end
