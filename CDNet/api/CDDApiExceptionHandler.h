//
//  CDDApiExceptionHandler.h
//  CDD
//
//  Created by HaiLai on 17/2/22.
//  Copyright © 2017年 HaiLai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDDApiExceptionHandler : NSObject
@property (nonatomic,strong) NSString *exceptionId;
@property (nonatomic,weak) id exceptionTargert;
@property (nonatomic,assign) SEL exceptionSelector;
@property (nonatomic,strong) id exceptionObject;

-(instancetype)initWithId:(nonnull NSString *)excepId target:(nonnull id)excepTarget Selector:(nonnull SEL)excepSelector Object:(nullable id)excepObject;
-(void)handlerExcute;
@end
