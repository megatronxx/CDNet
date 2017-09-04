//
//  CDDApi.h
//  CDD
//
//  Created by Megatron on 17/2/21.
//  Copyright © 2017年 HaiLai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CDDApiCallback)(NSDictionary *info);

typedef enum : NSUInteger {
    CDDApiStatusNone,
    CDDApiStatusLiving,
    CDDApiStatusTerminate,
} CDDApiStatus_t;

@class CDDApi;
@protocol CDDApiDelegate <NSObject>
@required
-(void)dealResult:(NSDictionary *)result forTarget:(CDDApi *)api;
@end

@interface CDDApi : NSObject
@property (nonatomic,strong) NSString *apiName;
@property (nonatomic,strong) NSMutableDictionary *apiParameter;
@property (nonatomic,strong) CDDApiCallback apiCallback;
@property (nonatomic,assign) CDDApiStatus_t apiStatus;
@property (nonatomic,weak) id<CDDApiDelegate> apiDelegate;

-(instancetype)initWithName:(nonnull NSString *)name parameter:(nonnull NSMutableDictionary *)para callback:(nonnull CDDApiCallback)callback delegate:(nonnull id<CDDApiDelegate>)delegate;

-(void)start;
-(void)terminate;
-(void)resume;
@end
