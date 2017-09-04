//
//  CDDApi.m
//  CDD
//
//  Created by Megatron on 17/2/21.
//  Copyright © 2017年 HaiLai. All rights reserved.
//

#import "CDDApi.h"
#import "WFHead.h"

@interface CDDApi ()
@property WFRequest *apiRequest;
@end

@implementation CDDApi
@synthesize apiName,apiParameter,apiCallback,apiStatus,apiDelegate;
@synthesize apiRequest;

#pragma mark - public method
-(void)start
{
    if (apiName.length > 0 && apiParameter && apiCallback) {
        [self launch];
    }
}

-(void)terminate
{
    [apiRequest closeConnect];
    apiStatus = CDDApiStatusTerminate;
}

-(void)resume
{
    [self launch];
}

#pragma mark - private method
-(void)launch
{
    apiStatus = CDDApiStatusLiving;
    @WeakObj(self)
    [apiRequest requestWithURL:apiName callBack:^(NSDictionary *info) {
        //获得结果
        apiStatus = CDDApiStatusTerminate;
        [selfp dealResult:info];
    } parameter:apiParameter];
}
-(void)dealResult:(NSDictionary *)result
{
    //预处理结果交给委托
    [apiDelegate dealResult:result forTarget:self];
}
#pragma mark - life
-(instancetype)initWithName:(nonnull NSString *)name parameter:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback delegate:(nonnull id<CDDApiDelegate>)delegate
{
    if (self = [super init]) {
        apiName = name;
        apiParameter = para;
        apiCallback = callback;
        apiStatus = CDDApiStatusNone;
        apiDelegate = delegate;
        apiRequest = [[WFRequest alloc]init];
        apiRequest.cacheType = WFRequestCacheTypeOffLineShow;
    }
    return self;
}
@end
