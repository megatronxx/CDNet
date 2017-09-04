//
//  WFCashManager.h
//  WFFrameWorkDeal
//
//  Created by 海莱 on 15/7/2.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#define CASH_DOCUMENT @"myCash"//缓存目录
#define CASH_IMGS @"imgs"//图片目录

///缓存完成通知
#define WF_CASH_DONE_NOTIFICATION   @"wf.cash.done.notification"

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#import "WFHead.h"

@interface WFCashManager : NSObject
{
    dispatch_queue_t myIOQueue;
}

+ (id)sharedManager;


///保存缓存图片
-(void)saveImageWithUrl:(NSString *)url;
///获取缓存图片
- (UIImage*)getCashImageWithUrl:(NSString*)url;

///获取cash文件夹
- (NSString*)getCashPath;
///获取文件完整路径
-(NSString*)getFilePath:(NSString*)fileName;
///获取带文件夹的文件路径 例子：my/abc/img
-(NSString*)getFilePath:(NSString *)fileName directory:(NSString*)directoryName;

///由图片的url生成图片名
-(NSString*)liGetImgNameFromURL:(NSString*)url;
///删除文件夹
- (BOOL)removeDocument:(NSString*)document;
///把图片设为按钮的背景
-(void)addImgToBtnFromDocumentORURL:(UIButton*)btn url:(NSString*)url;
///往imgView添加图片
-(void)addImgToImgViewFromDocumentORURL:(UIImageView*)imgView url:(NSString*)url;

///播放音乐
-(void)playVoiceFromDocumentORURL:(AVAudioPlayer*)player url:(NSString*)url;
///从文件获取图像
-(UIImage *)getImagefrompath:(NSString *)path;
@end
