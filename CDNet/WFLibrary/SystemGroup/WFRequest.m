//
//  WFRequest.m
//  FrameWorkDemo
//
//  Created by 海莱 on 15/10/8.
//  Copyright (c) 2015年 海莱. All rights reserved.
//
#pragma mark - 网络交互的核心

#import "WFRequest.h"
#import "WFHead.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define REQUEST_API                 @"requset_api"
#define REQUEST_PARAMETER           @"parameter"
#define REQUEST_BOUNDARY            @"AaB03x"
#define NET_CHECK_HOST_NAME         @"www.baidu.com"
#define WF_NET_FAIL                 @"郁闷，网络不能连接了"
#define WF_NET_TIMEOUT              @"网络不给力啊"
#define WF_NET_DATAERR              @"数据异常请稍后重试！"
#define WF_NET_LINKERR              @"链接出错请稍后重试！"
#define WF_NET_TIMEDURING           10 //网络请求允许的时间
/**
 *      定义几种网络出错类型
 *      404  数据异常
 *      11   断网状态
 *      12   连接出错
 */
//返回数据出错（格式、内容等）
#define NUM_NET_DATAERR             @"404"
#define NUM_NET_FAIL                @"11"
#define NUM_NET_CONNECT_FAIL        @"12"

///请求结果判定键
#define kRequestResult              @"success"

static NSString *requestKey;

@interface WFRequest ()
@property(nonatomic,strong)NSURL *requestURL;
@property(nonatomic,strong)NSURLConnection *connector;
@property(nonatomic,strong)NSMutableDictionary *requestParameters;
@property(nonatomic,strong)NSMutableData *receiveData;//服务器返回的数据
@property(nonatomic,assign)int requestType;//0 是纯文本 1 image/JPEG 2text/plain
@end

@implementation WFRequest
@synthesize isStopNetWorkActive,cacheType;
@synthesize connector,requestURL = _requestURL,requestParameters = _requestParameters,receiveData = _receiveData,requestType = _requestType;

///保存缓存
-(void)saveCache
{
    NSString *apiname = _requestURL.path.lastPathComponent;
//    NSLog(@"请求接口：%@",apiname);
    NSMutableDictionary *mrequestPara = [[NSMutableDictionary alloc]initWithDictionary:_requestParameters copyItems:YES];
    NSString *token = [mrequestPara objectForKey:@"token"] ?: @"";
    if (token.length > 0) {
        NSMutableArray *tokenms = [[NSMutableArray alloc]initWithArray:[token componentsSeparatedByString:@"_"]];
        NSString *randstr = tokenms[1];
        NSString *tokenf = [token stringByReplacingOccurrencesOfString:randstr withString:@"***"];
        [mrequestPara setObject:tokenf forKey:@"token"];
    }
//    NSLog(@"parameter : %@ and copy : %@",_requestParameters,mrequestPara.description);
    
    NSString *parameter = mrequestPara.description ?: @"no_para";
    //                    NSString *parameters = [AESCrypt decrypt:parameter password:@"hmsdev0"];
    NSString *path = [[WFCashManager sharedManager]getFilePath:parameter directory:apiname];
    
    NSString *resultstr = [[NSString alloc]initWithData:_receiveData encoding:NSUTF8StringEncoding];
    NSString *encryptedResult = [AESCrypt encrypt:resultstr password:@"hmsdev0"];
    [encryptedResult writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

///获得缓存
-(NSMutableDictionary *)getCache
{
    NSMutableDictionary *cache = [[NSMutableDictionary alloc]init];
    NSString *apiname = _requestURL.path.lastPathComponent;
    NSMutableDictionary *mrequestPara = [[NSMutableDictionary alloc]initWithDictionary:_requestParameters copyItems:YES];
    NSString *token = [mrequestPara objectForKey:@"token"] ?: @"";
    if (token.length > 0) {
        NSMutableArray *tokenms = [[NSMutableArray alloc]initWithArray:[token componentsSeparatedByString:@"_"]];
        NSString *randstr = tokenms[1];
        NSString *tokenf = [token stringByReplacingOccurrencesOfString:randstr withString:@"***"];
        [mrequestPara setObject:tokenf forKey:@"token"];
    }
    NSString *parameter = mrequestPara.description ?: @"no_para";
    //        NSString *parameters = [AESCrypt decrypt:parameter password:@"hmsdev0"];
    NSString *path = [[WFCashManager sharedManager]getFilePath:parameter directory:apiname];
    
    NSString *encryptedData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *mmessage = [AESCrypt decrypt:encryptedData password:@"hmsdev0"];
    NSDictionary *dic = [WFFunctions WFDictionaryWithJsonString:mmessage];
    NSMutableDictionary *resutl_cach = [NSMutableDictionary dictionaryWithDictionary:dic];
    cache = resutl_cach;
    return cache;
}

- (void)requestWithURL:(NSString *)url callBack:(requestHandler)handler parameter:(NSMutableDictionary *)paramters
{
    if (handler) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &requestKey, handler, OBJC_ASSOCIATION_COPY);
    }
    
    if(!self.requestURL)
        self.requestURL = [NSURL URLWithString:url];
    if(!self.requestParameters)
        self.requestParameters = paramters;
    NSLog(@"普通请求 url:%@ parameter:%@",self.requestURL,self.requestParameters);
    
    if([WFRequest canConnectNet])
    {
        if (cacheType == WFRequestCachePriorShow) {
            ///优先展示缓存
            NSMutableDictionary *resutl_cach = [self getCache];
            //返回数据
            requestHandler handler = objc_getAssociatedObject(self, &requestKey);
            handler(resutl_cach);
        }
        //
        self.requestType = [self getRequestType:_requestParameters];
        NSMutableURLRequest* theRequest = [[NSMutableURLRequest alloc] initWithURL:_requestURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:WF_NET_TIMEDURING];
        if(0 == _requestType)
        {
            [theRequest setHTTPMethod:@"POST"];
            NSData *postData = [self getPostData];
            [theRequest setHTTPBody:postData];
            [theRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
        }
        if(1 == _requestType)
        {
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", REQUEST_BOUNDARY]forHTTPHeaderField:@"Content-Type"];
            [theRequest setHTTPBody:[self getPostData]];
        }
        [self openConnector:theRequest];
    }
    else
    {
        if (cacheType == WFRequestCacheTypeNone) {
            ///不设置缓存
            NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",NUM_NET_FAIL,WF_NET_FAIL, nil] forKeys:[NSArray arrayWithObjects:kRequestResult,@"status",@"msg", nil]];
            requestHandler handler = objc_getAssociatedObject(self, &requestKey);
            handler(dic);
        }else{
            NSMutableDictionary *resutl_cach = [self getCache];
            //返回数据
            requestHandler handler = objc_getAssociatedObject(self, &requestKey);
            handler(resutl_cach);
        }
    }
}

- (void)requestWithAudioURL:(NSString *)url callBack:(requestHandler)handler parameter:(NSMutableDictionary *)paramters
{
    if (handler) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &requestKey, handler, OBJC_ASSOCIATION_COPY);
    }
    
    if(!self.requestURL)
        self.requestURL = [NSURL URLWithString:url];
    if(!self.requestParameters)
        self.requestParameters = paramters;
    NSLog(@"多媒体请求 url:%@ parameter:%@",self.requestURL,self.requestParameters);
    
    if([WFRequest canConnectNet])
    {
        if (cacheType == WFRequestCachePriorShow) {
            ///优先展示缓存
            NSMutableDictionary *resutl_cach = [self getCache];
            //返回数据
            requestHandler handler = objc_getAssociatedObject(self, &requestKey);
            handler(resutl_cach);
        }
        //
        NSMutableURLRequest* theRequest = [[NSMutableURLRequest alloc] initWithURL:_requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WF_NET_TIMEDURING];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", REQUEST_BOUNDARY]forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPBody:[self getAudioPostData]];
        [self openConnector:theRequest];
    }
    else
    {
        if (cacheType == WFRequestCacheTypeNone) {
            ///不设置缓存
            NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",NUM_NET_FAIL,WF_NET_FAIL, nil] forKeys:[NSArray arrayWithObjects:kRequestResult,@"status",@"msg", nil]];
            requestHandler handler = objc_getAssociatedObject(self, &requestKey);
            handler(dic);
        }else{
            NSMutableDictionary *resutl_cach = [self getCache];
            //返回数据
            requestHandler handler = objc_getAssociatedObject(self, &requestKey);
            handler(resutl_cach);
        }
    }
}

//手动关闭连接
- (void)closeConnect
{
    if(connector)
    {
        [connector cancel];connector = nil;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//打开连接请求
- (void)openConnector:(NSMutableURLRequest*)request
{
    //追加user_agent
    NSString *user_agent = [[NSUserDefaults standardUserDefaults]objectForKey:kUserAgent];
    [request setValue:user_agent forHTTPHeaderField:@"User-Agent"];
    //"正在连接"状态打开
    connector = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connector)
    {
        if(!isStopNetWorkActive)
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        self.receiveData = [[NSMutableData alloc] init];
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NUM_NET_CONNECT_FAIL,WF_NET_LINKERR, nil] forKeys:[NSArray arrayWithObjects:@"status",@"msg", nil]];
        requestHandler handler = objc_getAssociatedObject(self, &requestKey);
        handler(dic);
        
        [self closeConnect];
    }
}

//判断是否接收到了数据，如果没有，关闭连接
-(void)checkData:(id)sender
{
    if (0 == _receiveData.length)
    {
        if (connector)
        {
            [connector cancel];connector = nil;
        }
        
        //如果不是超时状态 弹出超时错误 打开超时状态
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",@"13",WF_NET_TIMEOUT, nil] forKeys:[NSArray arrayWithObjects:kRequestResult,@"status",@"msg", nil]];
        requestHandler handler = objc_getAssociatedObject(self, &requestKey);
        handler(dic);
    }
}

//检测网络状态
+ (BOOL)canConnectNet
{
    Reachability *reache = [Reachability reachabilityWithHostName:NET_CHECK_HOST_NAME];
    
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable://无网络
            return NO;
        case ReachableViaWiFi://wifi网络
            return YES;
        case ReachableViaWWAN://wwlan网络
            return YES;
        default:
            break;
    }
    return YES;
}

//获取请求类型 1 ： 有文件上传使用rfc1867协议 0 ：没有文件上传不适用rfc1867协议
- (int)getRequestType:(NSDictionary*)para
{
    for(NSObject *object in para.allValues)
    {
        //检索是不是含有文件
        if([object isKindOfClass:[NSData class]])
        {
            return 1;
        }
    }
    return 0;
}

//设置请求数据
- (NSData*)getPostData
{
    NSData *returnData = nil;
    if(0 == _requestType)
    {
        NSMutableString *temMutableString = [NSMutableString stringWithString:@""];
        for(NSString *key in _requestParameters.allKeys)
        {
            [temMutableString appendFormat:@"&%@=%@",key,[_requestParameters objectForKey:key]];
        }
        returnData = [temMutableString dataUsingEncoding:NSUTF8StringEncoding];
    }
    if(1 == _requestType)
    {
        NSMutableData *temMutableData = [[NSMutableData alloc] init];
        NSString *boundary = REQUEST_BOUNDARY;
        //rfc1867协议样式
        //        --AaB03x\r\n Content-Disposition:form-data;name="title"\r\n \r\n value\r\n
        //        --AaB03x\r\n Content-Disposition:form-data;name="imagetitle";filename="ab.jpg"\r\n Content-Type:image/JPEG\r\n \r\n datavalue\r\n
        //        --AaB03x--\r\n
        for(NSString *key in _requestParameters.allKeys)
        {
            if([[_requestParameters objectForKey:key] isKindOfClass:[NSString class]])
            {
                NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n",boundary,key,[_requestParameters objectForKey:key]];
                [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                //NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";filename=\"ab.jpg\"\r\n Content-Type:image/JPEG\r\n\r\n",boundary,key];
                NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";filename=\"ab.jpg\"\r\n Content-Type:image/jpeg\r\n\r\n",boundary,key];
                [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
                [temMutableData appendData:[_requestParameters objectForKey:key]];
                [temMutableData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        NSString *endStr = [NSString stringWithFormat:@"--%@--\r\n",boundary];
        [temMutableData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
        returnData = temMutableData;
    }
    return returnData;
}

//设置请求音频数据
- (NSData*)getAudioPostData
{
    NSData *returnData = nil;
    NSMutableData *temMutableData = [[NSMutableData alloc] init];
    NSString *boundary = REQUEST_BOUNDARY;
    for(NSString *key in _requestParameters.allKeys)
    {
        if([[_requestParameters objectForKey:key] isKindOfClass:[NSString class]])
        {
            NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n",boundary,key,[_requestParameters objectForKey:key]];
            [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";filename=ab.mp3\r\n Content-Type:audio/mpeg\r\n\r\n",boundary,key];
            [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
            [temMutableData appendData:[_requestParameters objectForKey:key]];
            [temMutableData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSString *endStr = [NSString stringWithFormat:@"--%@--\r\n",boundary];
    [temMutableData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
    returnData = temMutableData;
    return returnData;
}

#pragma mark- 后台重新登录
- (void)loginInBackground
{
    NSLog(@"后台重新登录:");
    //通知接收者重新登录
    [[NSNotificationCenter defaultCenter]postNotificationName:TokenFailNotification object:nil];
}
#pragma mark - 301 
-(void)deal301:(NSDictionary *)info
{
    NSLog(@"net error 301");
    [[NSNotificationCenter defaultCenter]postNotificationName:Fail301Notification object:info];
}
#pragma mark- NSUrlConnection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //可以获取数据的长度
    //    NSLog(@"response:%@",response);
    //    NSLog(@"length:%lld",response.expectedContentLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //        NSString *backStr = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
    //        NSLog(@"原始back:%@",backStr);
    
    //解析json数据
    if (_receiveData != nil) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
            [resultDictionary setObject:_requestParameters forKey:REQUEST_PARAMETER];
//            NSLog(@"请求结果：%@",resultDictionary);
            
            NSString *isAbort = [dictionary objectForKey:@"issysabort"] ?: @"0";
            if ([isAbort isEqualToString:@"1"]) {
                abort();
            }
            
            if (cacheType != WFRequestCacheTypeNone) {
                [self saveCache];
            }
            //返回数据
            requestHandler handler = objc_getAssociatedObject(self, &requestKey);
            handler(resultDictionary);
        }else{
            NSString *msg = WF_NET_DATAERR;
            NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",NUM_NET_DATAERR,msg, nil] forKeys:[NSArray arrayWithObjects:kRequestResult,@"status",@"msg", nil]];
            requestHandler handler = objc_getAssociatedObject(self, &requestKey);
            handler(dic);
        }
    }else{
        NSString *msg = WF_NET_DATAERR;
        NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",NUM_NET_DATAERR,msg, nil] forKeys:[NSArray arrayWithObjects:kRequestResult,@"status",@"msg", nil]];
        requestHandler handler = objc_getAssociatedObject(self, &requestKey);
        handler(dic);
    }
    
    [self closeConnect];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *msg = [NSString stringWithFormat:@"%@",[error localizedDescription]] ?: WF_NET_LINKERR;
    NSLog(@"connect 链接出错 msg:%@ \n方法名：%s",msg,__FUNCTION__);
    if ([msg containsString:@"超时"] || [msg containsString:@"timed out"]) {
        NSLog(@"超时信息: %@",connection);
        NSLog(@"超时错误信息: %@",error);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",NUM_NET_CONNECT_FAIL,@"", nil] forKeys:[NSArray arrayWithObjects:kRequestResult,@"status",@"msg", nil]];
        requestHandler handler = objc_getAssociatedObject(self, &requestKey);
        handler(dic);
    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",NUM_NET_CONNECT_FAIL,msg, nil] forKeys:[NSArray arrayWithObjects:kRequestResult,@"status",@"msg", nil]];
        //返回数据
        requestHandler handler = objc_getAssociatedObject(self, &requestKey);
        handler(dic);
    }
    
    [self closeConnect];
}

@end



#pragma mark - 系统管理者
@implementation WFManager
@synthesize registInfo;
@synthesize systemInitInfo;
@synthesize loginInfo;

+(WFManager *)shareManager
{
    static WFManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[WFManager alloc]init];
        }
    });
    return manager;
}

-(NSString *)loginToken
{
    NSString *token = [self.loginInfo objectForKey:@"token"] ?: @"";
    return token;
}
-(NSString *)loginId
{
    NSString *idd = [self.loginInfo objectForKey:@"id"] ?: @"";
    return idd;
}

-(void)clean
{
    if (self) {
        [registInfo removeAllObjects];
        registInfo = nil;
        [self cleanInit];
    }
}
-(void)cleanInit
{
    [systemInitInfo removeAllObjects];
    systemInitInfo = nil;
    [self cleanLogin];
}
-(void)cleanLogin
{
    [loginInfo removeAllObjects];
    loginInfo = nil;
}
-(void)cleanRegist
{
    [registInfo removeAllObjects];
    registInfo = nil;
}
@end


#pragma mark - 检查网络状态
/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 */

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>

#import <CoreFoundation/CoreFoundation.h>


#pragma mark IPv6 Support
//Reachability fully support IPv6.  For full details, see ReadMe.md.


NSString *kReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";


#pragma mark - Supporting functions

#define kShouldPrintReachabilityFlags 1

static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
    
    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)				? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );
#endif
}


static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(__bridge NSObject*) info isKindOfClass: [Reachability class]], @"info was wrong class in ReachabilityCallback");
    
    Reachability* noteObject = (__bridge Reachability *)info;
    // Post a notification to notify the client that the network reachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
}


#pragma mark - Reachability implementation

@implementation Reachability
{
    SCNetworkReachabilityRef _reachabilityRef;
}

+ (instancetype)reachabilityWithHostName:(NSString *)hostName
{
    Reachability* returnValue = NULL;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if (reachability != NULL)
    {
        returnValue= [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}


+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
    
    Reachability* returnValue = NULL;
    
    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}


+ (instancetype)reachabilityForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}

#pragma mark reachabilityForLocalWiFi
//reachabilityForLocalWiFi has been removed from the sample.  See ReadMe.md for more information.
//+ (instancetype)reachabilityForLocalWiFi



#pragma mark - Start and stop notifier

- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context))
    {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
        {
            returnValue = YES;
        }
    }
    
    return returnValue;
}


- (void)stopNotifier
{
    if (_reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}


- (void)dealloc
{
    [self stopNotifier];
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}


#pragma mark - Network Flag Handling

- (NetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    PrintReachabilityFlags(flags, "networkStatusForFlags");
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return NotReachable;
    }
    
    NetworkStatus returnValue = NotReachable;
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = ReachableViaWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = ReachableViaWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        returnValue = ReachableViaWWAN;
    }
    
    return returnValue;
}


- (BOOL)connectionRequired
{
    NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }
    
    return NO;
}


- (NetworkStatus)currentReachabilityStatus
{
    NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkReachabilityRef");
    NetworkStatus returnValue = NotReachable;
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        returnValue = [self networkStatusForFlags:flags];
    }
    
    return returnValue;
}

//检测网络状态
+(BOOL)canConnectNet
{
    Reachability *reache=[Reachability reachabilityWithHostName:@"https://www.baidu.com"];
    
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable://无网络
            return NO;
        case ReachableViaWiFi://wifi网络rr
            return YES;
        case ReachableViaWWAN://wwlan网络
            return YES;
        default:
            break;
    }
    return NO;
}
//检测网络是否是wifi
+(BOOL)canConnectWifi
{
    Reachability *reache=[Reachability reachabilityWithHostName:@"https://www.baidu.com"];
    
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable://无网络
            return NO;
        case ReachableViaWiFi://wifi网络rr
            return YES;
        case ReachableViaWWAN://wwlan网络
            return NO;
        default:
            break;
    }
    return NO;
}
@end
