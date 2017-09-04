//
//  CDDApiManager.m
//  CDD
//
//  Created by Megatron on 17/2/21.
//  Copyright © 2017年 HaiLai. All rights reserved.
//

#import "CDDApiManager.h"
#import "WFHead.h"

#define CDD_APINAME_KEY         @"name"
#define CDD_APIPARAMETER_KEY    @"parameter"
#define CDD_APICALLBACK_KEY     @"callback"

#define CDD_TOKENLOSE_CODE      @"99"

@interface CDDApiManager ()
@property (nonatomic,strong) NSMutableArray *apiQueue;
@end

@implementation CDDApiManager
@synthesize exceptionHandlerSource,API_VERSION,SYS_ROOT,REQUEST_MAINLINK;
@synthesize apiQueue;

#pragma mark - method
+(nonnull instancetype)shareManager
{
    static CDDApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[CDDApiManager alloc]init];
        }
    });
    return manager;
}

///
-(void)callApi:(nonnull NSString *)api withPara:(nonnull NSMutableDictionary *)para andCallback:(nonnull CDDApiCallback)callback
{
    ///新建一个api加入接口队列中，并开始接口
    CDDApi *cddapi = [[CDDApi alloc]initWithName:api parameter:para callback:callback delegate:self];
    [apiQueue addObject:cddapi];
    [cddapi start];
}

#pragma mark - private method
///初始化异常处理
-(void)initExceptionHandlerSource
{
    CDDApiExceptionHandler *tokenLoseHandler = [[CDDApiExceptionHandler alloc]initWithId:CDD_TOKENLOSE_CODE target:self Selector:@selector(tokenLoseDeal) Object:nil];
    [exceptionHandlerSource addObject:tokenLoseHandler];
}
///处理异常
-(void)dealException:(NSString *)errorCode
{
    for (CDDApiExceptionHandler *handler in exceptionHandlerSource) {
        if ([errorCode isEqualToString:handler.exceptionId]) {
            [handler handlerExcute];
            break;
        }
    }
}
-(void)addExceptionHandler:(nonnull CDDApiExceptionHandler*)excepHandler
{
    if (excepHandler) {
        [exceptionHandlerSource addObject:excepHandler];
    }
}
#pragma mark - exception method
///token失效异常处理
-(void)tokenLoseDeal
{
    
}

#pragma mark - life
-(instancetype)init
{
    if (self = [super init]) {
        apiQueue = [[NSMutableArray alloc]init];
        exceptionHandlerSource = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - delegate
#pragma mark - CDDApi delegate
-(void)dealResult:(NSDictionary *)result forTarget:(CDDApi *)api
{
    NSString *error_code = [result objectForKey:@"error_code"];
    if (error_code > 0) {
        [self dealException:error_code];
    }else{
        api.apiCallback(result);
        [exceptionHandlerSource removeObject:api];
    }
}

#pragma mark - project api list
-(void)webInitWithCallback:(nonnull CDDApiCallback)callback
{
    NSString *currentVersion = API_VERSION;
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:@"1" forKey:@"device_type"];
    [para setObject:[[[UIDevice currentDevice]identifierForVendor] UUIDString] forKey:@"device_sn"];
    [para setObject:currentVersion forKey:@"lastloginversion"];
    [para setObject:[WFFunctions WFSysGetMacaddress] forKey:@"mac"];
    [para setObject:[WFFunctions WFSysGetIdfa] forKey:@"idfa"];
    [para setObject:@"0" forKey:@"ios_from_local"];
    NSString *link = [NSString stringWithFormat:@"%@%@",SYS_ROOT,@"index.php/webservice/index/init"];
    [[CDDApiManager shareManager]callApi:link withPara:para andCallback:^(NSDictionary *info) {
        callback(info);
    }];
}

-(void)login:(NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback;
{
    NSString *link = [NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,@"client_login"];
    [[CDDApiManager shareManager]callApi:link withPara:para andCallback:^(NSDictionary *info) {
        callback(info);
    }];
}

-(void)goods_list:(NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback;
{
    
}
-(void)client_verify:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback
{
    NSString *link = [NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,@"client_verify"];
    [[CDDApiManager shareManager]callApi:link withPara:para andCallback:^(NSDictionary *info) {
        callback(info);
    }];
}
-(void)code_get:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback
{
    NSString *link = [NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,@"code_get"];
    [[CDDApiManager shareManager]callApi:link withPara:para andCallback:^(NSDictionary *info) {
        callback(info);
    }];
}
-(void)code_verify:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback
{
    NSString *link = [NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,@"code_verify"];
    [[CDDApiManager shareManager]callApi:link withPara:para andCallback:^(NSDictionary *info) {
        callback(info);
    }];
}
-(void)client_password_reset:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback
{
    NSString *link = [NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,@"client_password_reset"];
    [[CDDApiManager shareManager]callApi:link withPara:para andCallback:^(NSDictionary *info) {
        callback(info);
    }];
}
@end
