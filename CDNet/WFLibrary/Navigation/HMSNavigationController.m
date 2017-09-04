//
//  HMSNavigationController.m
//  ZGHMS
//
//  Created by 海莱 on 15/7/24.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import "HMSNavigationController.h"
#import "WFHead.h"

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define TOP_VIEW  [[UIApplication sharedApplication]keyWindow].rootViewController.view

@interface HMSNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end
@implementation HMSNavigationController
#pragma mark - event

+(id)hms_getNavigationController:(UIViewController *)viewController
{
    id nav = viewController.navigationController.navigationController;
    if ([nav isKindOfClass:[HMSNavigationController class]]) {
        return nav;
    }else{
        return viewController.navigationController;
    }
}
-(void)hms_replaceLastWithViewController:(UIViewController *)viewController
{
    NSArray *arr = self.viewControllers;
    if (arr.count > 0) {
        NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:arr];
        if ([viewController isKindOfClass:[YQWrapViewController class]]) {
            [marr setObject:viewController atIndexedSubscript:arr.count - 1];
        }else{
            [marr setObject:[YQWrapViewController wrapViewControllerWithViewController:viewController] atIndexedSubscript:arr.count - 1];
        }
        [self setViewControllers:marr animated:YES];
    }
}
-(void)hms_setViewController:(UIViewController *)viewController atIndex:(NSInteger)index
{
    NSArray *arr = self.viewControllers;
    if (index < arr.count) {
        NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:arr];
        if ([viewController isKindOfClass:[YQWrapViewController class]]) {
            [marr setObject:viewController atIndexedSubscript:index];
        }else{
            [marr setObject:[YQWrapViewController wrapViewControllerWithViewController:viewController] atIndexedSubscript:index];
        }
        
    }
}
-(void)hms_setViewControllers:(NSArray *)viewControllers
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    [marr removeAllObjects];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[YQWrapViewController class]]) {
            [marr addObject:vc];
        }else{
            [marr addObject:[YQWrapViewController wrapViewControllerWithViewController:vc]];
        }
    }
    [self setViewControllers:marr animated:YES];
}
#pragma mark - life
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super init]) {
        
        self.viewControllers = @[[YQWrapViewController wrapViewControllerWithViewController:rootViewController]];
//        self.viewControllers = @[[[YQWrapNavigationController alloc]initWithRootViewController:rootViewController]];
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarHidden:YES];
}
#pragma mark - delegate
@end

