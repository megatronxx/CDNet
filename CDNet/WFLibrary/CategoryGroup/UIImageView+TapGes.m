//
//  UIImageView+TapGes.m
//  AssociatedDemo
//
//  Created by lipeng on 14-9-5.
//  Copyright (c) 2014年 lipeng. All rights reserved.
//

#import "UIImageView+TapGes.h"
#import <objc/runtime.h>

static const void *TapKey = &TapKey;
static const void *BigImgUrl = &BigImgUrl;
static const void *TemUrl = &TemUrl;
@implementation UIImageView (TapGes)

- (void)dealloc
{
    //NSLog(@"销毁img");
    objc_removeAssociatedObjects(self);
    
    
}

- (UITapGestureRecognizer*)Tap
{
    return objc_getAssociatedObject(self, TapKey);
}

- (void)setTap:(UITapGestureRecognizer*)p_tap
{
    objc_setAssociatedObject(self, TapKey, p_tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addTarget:(id)p_target action:(SEL)p_action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:p_target action:p_action];
    [self addGestureRecognizer:ges];
    [self setTap:ges];
    
}

- (NSString *)BigImgUrl
{
    return objc_getAssociatedObject(self, BigImgUrl);
}

- (void)setBigImgUrl:(NSString*)p_url
{
    objc_setAssociatedObject(self, BigImgUrl, p_url, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)TemUrl
{
    return objc_getAssociatedObject(self, TemUrl);
}

- (void)setTemUrl:(NSString*)p_url
{
    objc_setAssociatedObject(self, TemUrl, p_url, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
