//
//  LocationManager.m
//  LocationManager
//
//  Created by 海莱 on 15/8/5.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import "LocationManager.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationManager ()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *lManager;
@end

@implementation LocationManager
@synthesize localProvince,localCity,localDistrict;
@synthesize lManager;

+(LocationManager*)shareManager
{
    static LocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[LocationManager alloc]init];
        }
    });
    return manager;
}

-(instancetype)init
{
    if (self = [super init]) {
        localProvince = @"";
        localCity = @"";
        localDistrict = @"";
        
        lManager = [[CLLocationManager alloc]init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [lManager requestWhenInUseAuthorization];
        [lManager setDelegate:self];
        //要求CLLocationManager对象返回全部结果
        [lManager setDistanceFilter:kCLDistanceFilterNone];
        //要求CLLocationManager对象的返回结果尽可能的精准
        [lManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return self;
}


-(void)beginLocation
{
    [lManager startUpdatingLocation];
}

-(void)stopLocation
{
    [lManager stopUpdatingLocation];
}
#pragma - mark 委托
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s定位失败：%@",__FUNCTION__,error);
    [lManager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //得到newLocation
    CLLocation *location = locations[0];
    
    //定位城市通过CLGeocoder
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString *administrativeArea = [placemark administrativeArea];
            NSString *locality = [placemark locality];
            NSString *subLocality = [placemark subLocality];
            if (error) {
                
            }else{
                localProvince = administrativeArea;
                localCity = locality;
                localDistrict = subLocality;
            }
            NSLog(@"定位：%@ \n%@ \n%@ \n",localProvince,localCity,localDistrict);
            [[NSNotificationCenter defaultCenter]postNotificationName:PositionChooseNotification object:@{@"province":localProvince,@"city":localCity,@"district":localDistrict}];
        }
    }];
    [lManager stopUpdatingLocation];
}
@end
