//
//  HMSBaseNavigationController.h
//  ZGHMS
//
//  Created by HaiLai on 16/6/18.
//  Copyright © 2016年 海莱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMSBaseNavigationController : UINavigationController
@property (nonatomic, assign) BOOL fullScreenPopGestureEnable; /**<是否开启全屏侧滑返回手势*/
@end

/**
 *  真正意义上的展示的导航视图
 *
 *  @return 展示的导航视图
 */
#pragma mark - YQWrapNavigationController

@interface YQWrapNavigationController : UINavigationController
@end


/**
 *  导航视图的父视图
 *
 *  @param YQWrapViewController YQWrapViewController Object
 *
 *  @return 导航视图的父视图
 */
#pragma mark - YQWrapViewController
@interface YQWrapViewController : UIViewController

+ (YQWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end
