//
//  QRCodeView.h
//  ZGHMS
//
//  Created by HaiLai on 15/12/17.
//  Copyright © 2015年 海莱. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRScanHandler)(NSDictionary *info,NSError *err);

@interface QRCodeView : UIView
-(instancetype)initWithHandler:(QRScanHandler)handler;
-(void)startScan;
+(UIImage *)createQRForString:(NSString *)qrString andQrImageName:(NSString *)qrImageName;
@end
