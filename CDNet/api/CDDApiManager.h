//
//  CDDApiManager.h
//  CDD
//
//  Created by Megatron on 17/2/21.
//  Copyright © 2017年 HaiLai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDDApi.h"
#import "CDDApiExceptionHandler.h"

@interface CDDApiManager : NSObject<CDDApiDelegate>
///处理各种情况的回调方法队列
@property (nonnull,nonatomic,strong) NSMutableArray *exceptionHandlerSource;
@property (nonnull,nonatomic,strong) NSString *API_VERSION;
@property (nonnull,nonatomic,strong) NSString *SYS_ROOT;
@property (nonnull,nonatomic,strong) NSString *REQUEST_MAINLINK;
+(nonnull instancetype)shareManager;

///api 参数 回调
-(void)callApi:(nonnull NSString *)api withPara:(nonnull NSMutableDictionary *)para andCallback:(nonnull CDDApiCallback)callback;
///创建各种特殊情况的处理
-(void)addExceptionHandler:(nonnull CDDApiExceptionHandler*)excepHandler;

#pragma mark - project api list
-(void)webInitWithCallback:(nonnull CDDApiCallback)callback;

-(void)login:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback;
-(void)goods_list:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback;
-(void)client_verify:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback;
-(void)code_get:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback;
-(void)code_verify:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback;
-(void)client_password_reset:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback;
@end
