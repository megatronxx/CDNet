//
//  WFRequest.h
//  FrameWorkDemo
//
//  Created by 海莱 on 15/10/8.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#pragma mark - 网络交互的核心
#import <Foundation/Foundation.h>

///301处理
#define Fail301Notification             @"fail301.notification"
///一个token失效，重新登陆的通知
#define TokenFailNotification           @"token.fail.notification"
///处理推送通知
#define DealPushNotification            @"deal.push.notification"
///user agent
#define kUserAgent      @"UserAgent"

typedef enum : NSUInteger {
    WFRequestCacheTypeNone,
    WFRequestCacheTypeOffLineShow,
    WFRequestCachePriorShow,
} WFRequestCacheType_t;

typedef void(^requestHandler)(NSDictionary *info);

@interface WFRequest : NSObject
@property(nonatomic,assign)BOOL isStopNetWorkActive;//是否禁止状态栏的网络菊花
@property (nonatomic,assign) WFRequestCacheType_t cacheType;
///一般
- (void)requestWithURL:(NSString *)url callBack:(requestHandler)handler parameter:(NSMutableDictionary *)paramters;
///多媒体
- (void)requestWithAudioURL:(NSString *)url callBack:(requestHandler)handler parameter:(NSMutableDictionary *)paramters;
//手动关闭连接
- (void)closeConnect;
@end

#pragma mark - 系统管理者
@interface WFManager : NSObject
@property (nonatomic,strong) NSMutableDictionary *registInfo;
@property (nonatomic,strong) NSMutableDictionary *systemInitInfo;
@property (nonatomic,strong) NSMutableDictionary *loginInfo;


+(WFManager *)shareManager;

-(NSString *)loginToken;
-(NSString *)loginId;

-(void)clean;
-(void)cleanInit;
-(void)cleanLogin;
-(void)cleanRegist;
@end

#pragma mark - 检查网络状态
/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
*/

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


typedef enum : NSInteger {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

#pragma mark IPv6 Support
//Reachability fully support IPv6.  For full details, see ReadMe.md.


extern NSString *kReachabilityChangedNotification;


@interface Reachability : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;


#pragma mark reachabilityForLocalWiFi
//reachabilityForLocalWiFi has been removed from the sample.  See ReadMe.md for more information.
//+ (instancetype)reachabilityForLocalWiFi;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

- (NetworkStatus)currentReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;

//检测网络状态
+(BOOL)canConnectNet;
//检测网络是否是wifi
+(BOOL)canConnectWifi;
@end
