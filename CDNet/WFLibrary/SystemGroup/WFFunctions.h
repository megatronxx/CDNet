//
//  WFFunctions.h
//  WFFrameWorkDeal
//
//  Created by 海莱 on 15/7/2.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

typedef enum tagBorderType
{
    BorderTypeDashed,
    BorderTypeSolid
}BorderType;

@interface WFFunctions : NSObject

//字符串相关函数=============================================================
///获取汉字首字母
+ (NSString *)WFStrGetFirstCharactor:(NSString *)aString;
///空字符校验
+(Boolean) WFStrCheckEmpty:(NSString *)p_str;
///判断字符串是否包含某个字符
+ (BOOL)WFStrContent:(NSString*)p_str inString:(NSString*)p_pStr;
///过滤空数据
+ (NSString*)WFStrGetFromStr:(NSString*)p_str;
///根据限定宽度和字体确定字符串的自适应尺寸
+ (CGSize)WFStrGetSize:(NSString*)str width:(float)width font:(UIFont*)font;
+ (CGRect)WFStrGetSize:(NSAttributedString*)astr width:(float)width;
///
///根据限定宽度和字体确定富文本的自适应frame
+ (CGRect)WFStrGetRect:(NSString*)str width:(CGFloat)width;

///电话号码校验
+ (BOOL)WFStrIsMobileNumber:(NSString *)mobileNum;
///邮箱校验
+ (BOOL)WFStrIsEmail:(NSString*)email;
///货币校验
+ (BOOL)WFStrIsMoney:(NSString*)money;
///密码校验
+ (BOOL)WFStrIsPWD:(NSString*)p_pwd;//是不是密码
///身份证校验
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
///将字典或者数组转化为data
+ (NSData *)WFToJSONData:(id)theData;
///字符串转为字典
+ (NSDictionary *)WFDictionaryWithJsonString:(NSString *)jsonString;
///字典转为字符串
+ (NSString*)WFConvertToJSONData:(id)infoDict;
//时间相关函数=============================================================
///获得本地时间
+ (NSDate*)WFTimeGetNowDate;
///获得yyyy-MM-dd HH:mm:ss格式的时间字符串
+ (NSString*)WFTimeGetNowStr;
///根据时间格式获得时间的对应时间字符串
+ (NSString*)WFTimeGetStringFromDate:(NSDate*)p_date byFormatter:(NSString*)p_formatter;
///获得时间差
+ (CGFloat)WFGetDateDifference:(NSString*)oldDateStr newDate:(NSString*)newDateStr;
///获得从某个时间到现在的时间描述：几分钟前等
+ (NSString *)WFTimeGetTimeFromDate:(NSString *)fromDate;
///获取天数
+ (NSInteger)WFTimeGetDifDayStartDate:(NSString *)p_startDate endDate:(NSString*)p_endDate;
///获取分钟数```
+ (NSInteger)WFTimeGetDifMinStartDate:(NSString *)p_startDate endDate:(NSString*)p_endDate;
///获得剩余时间
+ (NSString *)WFTimeGetStringToDate:(NSString *)toDate;
///获得剩余时间：天，时，分，秒
+ (NSDictionary *)WFTimeGetTimesToDate:(NSString *)toDate;
///按照格式返回时间字符
+ (NSString *)WFTimeGetString:(NSDate *)date byFormatter:(NSString *)formatter;
//视图相关函数=============================================================
///描边默认：0.5宽，5圆角，亮银色
+ (BOOL)WFUIaddBorderToView:(UIView*)p_view;
///根据圆角、宽度和颜色描边
+ (BOOL)WFUIaddbordertoView:(UIView*)view radius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color;
///根据圆角、宽度和颜色描虚线
+ (BOOL)WFUIadddashtoView:(UIView*)view radius:(CGFloat)radius width:(CGFloat)width dashPattern:(CGFloat)dashPattern spacePattern:(CGFloat)spacePattern color:(UIColor*)color borderType:(BorderType)type;
///分别描边
+ (void)WFUIaddBorderToView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;
///圆角默认：一半高度
+ (BOOL)WFUIMakeRadiusWithView:(UIView*)p_view;//
///添加动画
+ (void)WFUIBeginAnimations:(NSTimeInterval)duration view:(UIView*)view withHandler:(void(^)(UIView * temView))block;
///根据比例压缩图片
+ (UIImage *)WFUIScaleImage:(UIImage *)image toScale:(float)scale;
///拍照或者从相册获取图片结束后裁剪图片
+ (UIImage*)WFUIGetImage:(UIImage*)image;
///剪裁后图片添加上下黑边
+ (UIImage*)WFUIImageToSquare:(UIImage*)image;
///从颜色创建图片
+ (UIImage *)WFUICreateImageWithColor:(UIColor *)color;
//通过view获取cell
+ (UITableViewCell*)WFUIGetCellFromView:(UIView*)sender;
//通过view获取collection cell
+ (UICollectionViewCell*)WFUIGetCollectionCellFromView:(UIView*)sender;
//隐藏tabBar
+ (BOOL)WFHideTabBar:(UITabBarController *) tabbarcontroller duration:(NSTimeInterval)duration;
//显示tabBar
+ (BOOL)WFShowTabBar:(UITabBarController *) tabbarcontroller duration:(NSTimeInterval)duration;

//系统相关函数=============================================================
///获得硬件mac地址
+ (NSString *)WFSysGetMacaddress;
///获取idfa
+ (NSString*)WFSysGetIdfa;
///获取应用版本号
+ (NSString*)WFSysGetAppVersion;
///寻找第一响应者
+ (id)WFSysGettraverseResponder:(UIView*)view;
///寻找UITableviewCell
+ (UITableViewCell*)WFSysGetCellFromView:(UIView*)paraView;
///为键盘添加完成按钮
+(void)WFSysddFinishButtonForText:(id)sender withSelector:(SEL)selector andTarget:(id)target;
///获得urlquery字典信息
+ (NSDictionary*)WFGetDictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding;
//颜色====================================================================
//从十六进制字符串获取颜色 color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)WFColorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
//其他====================================================================
///一个alert动画
+ (void)WFExChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur;
///一个push动画
+ (void)WFPusht:(UIView *)changeOutView dur:(CFTimeInterval)dur;
///一个pop动画
+ (void)WFPop:(UIView *)changeOutView dur:(CFTimeInterval)dur;
///传说中的touchid
+ (void)authenticateUserWithCallBack:(void (^)(NSDictionary *info,NSError *error))handler;
@end
