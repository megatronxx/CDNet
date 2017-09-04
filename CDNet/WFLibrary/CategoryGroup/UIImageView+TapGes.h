//
//  UIImageView+TapGes.h
//  AssociatedDemo
//
//  Created by lipeng on 14-9-5.
//  Copyright (c) 2014年 lipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (TapGes)

- (UITapGestureRecognizer*)Tap;

- (NSString *)BigImgUrl;
- (void)setBigImgUrl:(NSString*)p_url;

- (NSString*)TemUrl;
- (void)setTemUrl:(NSString*)p_url;

- (void)addTarget:(id)p_target action:(SEL)p_action;
@end
