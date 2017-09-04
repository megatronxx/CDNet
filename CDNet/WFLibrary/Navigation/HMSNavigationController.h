//
//  HMSNavigationController.h
//  ZGHMS
//
//  Created by 海莱 on 15/7/24.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSBaseNavigationController.h"

@interface HMSNavigationController : HMSBaseNavigationController
+(id)hms_getNavigationController:(UIViewController *)viewController;
-(void)hms_replaceLastWithViewController:(UIViewController *)viewController;
-(void)hms_setViewController:(UIViewController *)viewController atIndex:(NSInteger)index;
-(void)hms_setViewControllers:(NSArray *)viewControllers;
@end
