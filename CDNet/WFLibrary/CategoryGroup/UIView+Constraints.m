//
//  UIView+Constraints.m
//  AtuolayoutDemo
//
//  Created by 海莱 on 15/9/28.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import "UIView+Constraints.h"

@implementation UIView (Constraints)
-(void)addSubview:(UIView *)view withDescription:(NSDictionary *)des
{
    if (des.count == 3) {
        [self addSubview:view];
        NSString *vstr = [des objectForKey:VDesKey];
        NSString *hstr = [des objectForKey:HDesKey];
        
        NSDictionary *views = [des objectForKey:ViewDesKey];
        
        NSLog(@"约束信息：%@",des);
        NSArray *titlearrayv = [NSLayoutConstraint constraintsWithVisualFormat:vstr options:0 metrics:nil views:views];
        NSArray *titlearrayh = [NSLayoutConstraint constraintsWithVisualFormat:hstr options:0 metrics:nil views:views];
        [self addConstraints:titlearrayv];
        [self addConstraints:titlearrayh];
    }else {
        NSLog(@"约束对象不完整：%@",des);
    }
}
@end
