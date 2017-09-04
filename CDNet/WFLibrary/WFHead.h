//
//  WFHead.h
//  WFFrameWorkDeal
//
//  Created by 海莱 on 15/7/2.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#ifndef WFFrameWorkDeal_WFHead_h
#define WFFrameWorkDeal_WFHead_h

#pragma mark - 头文件 =============================================
///特别的导航
#import "HMSNavigationGroup.h"
///MBProgressHUD组（信息提示）
#import "MBProgressHUDGroup.h"
///图片查看
//#import "PhotoShowGroup.h"
///类别组
#import "CategoryGroup.h"
///滚动视图组
//#import "CycleScrollGroup.h"
///分段选取
//#import "RFSegmentView.h"
///缓存组
#import "CacheGroup.h"
///侧滑菜单
//#import "SlideMenuGroup.h"
///加载刷新组
//#import "FreshAddGroup.h"
///系统组
#import "SystemGroup.h"
///二维码
#import "QRCodeGroup.h"
///滚动标题菜单
//#import "SlideBarGroup.h"
///地位城市单例
#import "LocationManager.h"
///滚动显示的label
//#import "MarqueeLabel.h"
///视频播放
//#import "VedioVC.h"
///一种弹出menu
//#import "FTPopOverMenu.h"
///自定义tabbar
//#import "XZMTabbarExtension.h"
///自定义的segmentcontrol
//#import "HMSegmentedControl.h"
///带block的timer
#import "HWWeakTimer.h"
///改变navigationbar颜色
#import "UINavigationBar+Awesome.h"
///图片编辑
//#import "CLImageEditor.h"
///
//#import "AttributeView.h"
///action sheet
//#import "WFActionSheet.h"
///web progress
//#import "WebProgressGroup.h"
#import "AESCrypt.h"
///一个通用编辑页面
//#import "BWEditorVC.h"

#pragma mark - 预处理 =============================================
///int的区间比较
#define l(a,x)              (a < x)
#define el(a,x)             (a <= x)
#define g(a,x)              (a > x)
#define eg(a,x)             (a >= x)
#define lg(a,x,y)           (a < y && a > x)
#define elg(a,x,y)          (a < y && a >= x)
#define leg(a,x,y)          (a <= y && a > x)
#define eleg(a,x,y)         (a <= y && a >= x)

///若引用
#define WeakObj(o) autoreleasepool{} __weak __block typeof(o) o##p = o;
///16进制
#define HEXCOLOR(str)                       [WFFunctions WFColorWithHexString:str alpha:1]
#define HEXCOLORALPHA(str,alp)              [WFFunctions WFColorWithHexString:str alpha:alp]
///三基色
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
///检测屏幕尺寸是否是4.7英寸
#define WF_ISIPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
///检测操作系统是否大于等于7.0
#define WF_IS_IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
///根据屏幕尺寸，决定启动页图片：image编号 1.iphone4s 2.iphone5/5s 3.iphone6 4.iphone6+
#define WF_UI_NUM ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)?1: (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)?2: (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)?3: (CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)?4:1 )))): 1)
///带navigationbar View 的高度
#define WF_UI_VIEW_HEIGHT ([[UIScreen mainScreen]bounds].size.height-64)
///不带navigationbar View 的高度
#define WF_UI_VIEW_WIDTH [[UIScreen mainScreen]bounds].size.width
///防止perform sel内存泄露的宏
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
///是否是调试
#define SYS_ISDEBUG                         false
///自定义log
//#ifdef DEBUG
//# define NSLog(fmt, ...) SYS_ISDEBUG ? NSLog(@"") : NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//# define NSLog(...);
//#endif

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

///GCD 的宏定义
//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);
///判断模拟器环境
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

#pragma mark - 按照5的屏幕尺寸，等比缩放的适配方案核心 ============================================
#define ScaleScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScaleScreenWidth     [[UIScreen mainScreen] bounds].size.width

#define autoSizeScaleX          ScaleScreenHeight > 480 ? (CGFloat)ScaleScreenWidth / 320.0f : 1
#define autoSizeScaleY          ScaleScreenHeight > 480 ? (CGFloat)ScaleScreenHeight / 568.0f : 1

CG_INLINE CGFloat
WFCGFloatX(CGFloat num) {
    CGFloat scalex = autoSizeScaleX;
    CGFloat xnum = num * scalex;
    return xnum;
}

CG_INLINE CGFloat
WFCGFloatBackX(CGFloat num) {
    CGFloat scalex = autoSizeScaleX;
    CGFloat xnum = num / scalex;
    return xnum;
}

CG_INLINE CGFloat
WFCGFloatY(CGFloat num) {
    CGFloat scaley = autoSizeScaleY;
    CGFloat ynum = num * scaley;
    return ynum;
}

CG_INLINE CGFloat
WFCGFloatBackY(CGFloat num) {
    CGFloat scaley = autoSizeScaleY;
    CGFloat ynum = num / scaley;
    return ynum;
}

CG_INLINE CGSize
WFCGSizeMake(CGFloat width, CGFloat height)
{
    CGSize size;
    CGFloat scalex = autoSizeScaleX;
    CGFloat scaley = autoSizeScaleY;
    CGFloat wwidth = width * scalex;
    CGFloat hheight = height * scaley;
    size = CGSizeMake(wwidth, hheight);
    return size;
}

CG_INLINE CGRect
WFCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    CGFloat scalex = autoSizeScaleX;
    CGFloat scaley = autoSizeScaleY;
    CGFloat xx = x * scalex;
    CGFloat yy = y * scaley;
    CGFloat wwidth = width * scalex;
    CGFloat hheight = height * scaley;
    rect = CGRectMake(xx, yy, wwidth, hheight);
    return rect;
}
CG_INLINE CGPoint
WFCGPointMake(CGFloat x, CGFloat y)
{
    CGPoint point;
    CGFloat scalex = autoSizeScaleX;
    CGFloat scaley = autoSizeScaleY;
    CGFloat xx = x * scalex;
    CGFloat yy = y * scaley;
    point = CGPointMake(xx, yy);
    return point;
}
#endif
