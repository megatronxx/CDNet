//
//  LocationManager.h
//  LocationManager
//
//  Created by 海莱 on 15/8/5.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PositionChooseNotification       @"positonchanged"

@interface LocationManager : NSObject
@property (nonatomic,copy) __block NSString *localProvince;
@property (nonatomic,copy) __block NSString *localCity;
@property (nonatomic,copy) __block NSString *localDistrict;
+(LocationManager*)shareManager;

-(void)beginLocation;
-(void)stopLocation;
@end
