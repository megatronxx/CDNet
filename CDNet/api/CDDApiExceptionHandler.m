//
//  CDDApiExceptionHandler.m
//  CDD
//
//  Created by HaiLai on 17/2/22.
//  Copyright © 2017年 HaiLai. All rights reserved.
//

#import "CDDApiExceptionHandler.h"

@implementation CDDApiExceptionHandler
@synthesize exceptionId,exceptionTargert,exceptionSelector,exceptionObject;

-(instancetype)initWithId:(nonnull NSString *)excepId target:(nonnull id)excepTarget Selector:(nonnull SEL)excepSelector Object:(nullable id)excepObject
{
    if (self = [super init]) {
        exceptionId = excepId;
        exceptionTargert = excepTarget;
        exceptionSelector = excepSelector;
        exceptionObject = excepObject;
    }
    return self;
}

-(void)handlerExcute
{
    [exceptionTargert performSelectorOnMainThread:exceptionSelector withObject:exceptionObject waitUntilDone:YES];
}
@end
