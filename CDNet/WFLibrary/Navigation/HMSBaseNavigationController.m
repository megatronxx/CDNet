//
//  HMSBaseNavigationController.m
//  ZGHMS
//
//  Created by HaiLai on 16/6/18.
//  Copyright © 2016年 海莱. All rights reserved.
//

#import "HMSBaseNavigationController.h"
#import "WFHead.h"

@interface HMSBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *popPanGesture;
@end

@implementation HMSBaseNavigationController
#pragma mark - event
//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}
#pragma mark - method
#pragma mark - static method
#pragma mark - public method
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}
#pragma mark - private method
#pragma mark - life
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        self.viewControllers = @[[YQWrapViewController wrapViewControllerWithViewController:rootViewController]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarHidden:YES];
    self.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.fullScreenPopGestureEnable) {
        id target = self.interactivePopGestureRecognizer.delegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        [self.view addGestureRecognizer:self.popPanGesture];
        self.popPanGesture.maximumNumberOfTouches = 1;
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - delegate
#pragma mark - UINavigationControllerDelegate
//解决某些情况push会卡死的情况
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    if (self.fullScreenPopGestureEnable) {
        if (isRootVC) {
            [self.popPanGesture removeTarget:target action:action];
        } else {
            [self.popPanGesture addTarget:target action:action];
        }
    } else {
        [self.popPanGesture removeTarget:target action:action];
    }
    self.interactivePopGestureRecognizer.enabled = !isRootVC;
}
@end

/**
 *  展示视图NavigationController
 */
@implementation YQWrapNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *titleColor = [WFFunctions WFColorWithHexString:@"#393939" alpha:1];
    NSDictionary *titleDict = @{NSFontAttributeName:[UIFont systemFontOfSize:16 withScale:autoSizeScaleX],
                                NSForegroundColorAttributeName:titleColor};
    
    if(WF_IS_IOS7_OR_LATER)
    {
        self.navigationBar.titleTextAttributes = titleDict;//标题字体
        self.navigationBar.tintColor = titleColor;//左右按钮颜色
        self.navigationBar.shadowImage = [UIImage new];
        
        //自定义返回按钮
        UIImage *backButtonImage = [UIImage imageNamed:@"HMSNavBack"];
        backButtonImage = [backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonImage.size.width, 0, 0)];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 withScale:autoSizeScaleX], NSFontAttributeName,nil] forState:UIControlStateNormal];
    }
    else
    {
        self.navigationBar.tintColor = [UIColor grayColor];
        self.navigationBar.titleTextAttributes = titleDict;//标题字体
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    HMSNavigationController *na = (HMSNavigationController *)self.navigationController;
    return [na popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    HMSNavigationController *na = (HMSNavigationController *)self.navigationController;
    
    return [na popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    HMSNavigationController *na = (HMSNavigationController *)self.navigationController;
    NSInteger index = [na.viewControllers indexOfObject:viewController];
    return [na popToViewController:na.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIImage *backButtonImage = [UIImage imageNamed:@"HMSNavBack"];
    backButtonImage = [backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonImage.size.width, 0, 0)];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
//    viewController.hidesBottomBarWhenPushed = YES;
    HMSNavigationController *na = (HMSNavigationController *)self.navigationController;
    [na pushViewController:[YQWrapViewController wrapViewControllerWithViewController:viewController] animated:animated];
}

- (void)didTapBackButton {
    HMSNavigationController *na = (HMSNavigationController *)self.navigationController;
    [na popViewControllerAnimated:YES];
}

@end

/**
 *  父视图
 */
@implementation YQWrapViewController

+ (YQWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController {
    
    YQWrapNavigationController *wrapNavController = [[YQWrapNavigationController alloc] init];
    YQWrapViewController *wrapViewController = [[YQWrapViewController alloc] init];
//    viewController.hidesBottomBarWhenPushed = YES;
    [wrapViewController.view addSubview:wrapNavController.view];
    [wrapViewController addChildViewController:wrapNavController];
    wrapNavController.viewControllers = @[viewController];
    return wrapViewController;
}
@end
