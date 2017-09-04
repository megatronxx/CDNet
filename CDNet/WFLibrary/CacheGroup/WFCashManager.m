//
//  WFCashManager.m
//  WFFrameWorkDeal
//
//  Created by 海莱 on 15/7/2.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import "WFCashManager.h"

static WFCashManager *sharedCashManager = nil;

@implementation WFCashManager

#pragma mark- 接口相关
//删除文件
- (BOOL)removeDocument:(NSString*)document
{
    NSString *directory = [self getFilePath:document];//NSLog(@"删除文件蹑:%@",directory);
    return [self deleteFileAtPaths:directory];
}

//把图片设为按钮的背景
-(void)addImgToBtnFromDocumentORURL:(UIButton*)btn document:(NSString*)document url:(NSString*)url
{
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    [btn setBackgroundImage:nil forState:UIControlStateDisabled];
    
    NSString *temImgName = [self liGetImgNameFromURL:url];btn.titleLabel.text = url;
    NSString *temImgPath = [self getFilePath:temImgName directory:document];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        UIImage *img = [self getImagefrompath:temImgPath];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setBackgroundImage:img forState:UIControlStateDisabled];
    }
    else
    {
        [self addActivity:btn];
        dispatch_async(myIOQueue, ^(void){
            UIImage *img = [self loadImagefromUrl:url];
            [self savepicturefromimage:img path:temImgPath];
            if([btn.titleLabel.text isEqualToString:url])
            {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self stopActivity:btn];
                    if(btn)
                    {
                        [btn setBackgroundImage:img forState:UIControlStateNormal];
                        [btn setBackgroundImage:img forState:UIControlStateDisabled];
                    }
                });
            }
            else
            {
                NSLog(@"不一致");
            }
            
        });
    }
}

-(void)addImgToBtnFromDocumentORURL:(UIButton*)btn url:(NSString*)url
{
    NSString *document = [NSString stringWithFormat:@"%@/%@",CASH_DOCUMENT,CASH_IMGS];
    [self addImgToBtnFromDocumentORURL:btn document:document url:url];
}

//往imgView添加图片
-(void)addImgToImgViewFromDocumentORURL:(UIImageView*)imgView document:(NSString*)document url:(NSString*)url
{
//    imgView.image = [UIImage imageNamed:@"商品列表默认图标"];
    NSString *temImgName = [self liGetImgNameFromURL:url];
    NSString *temImgPath = [self getFilePath:temImgName directory:document];//NSLog(@"temimgpath:%@",temImgPath);
    [imgView setTemUrl:url];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        UIImage *img = [self getImagefrompath:temImgPath];
        imgView.image = img;
    }
    else
    {
        [self addActivity:imgView];
        dispatch_async(myIOQueue, ^(void){
            UIImage *img = [self loadImagefromUrl:url];
            [self savepicturefromimage:img path:temImgPath];
            
            if([imgView.TemUrl isEqualToString:url])
            {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self stopActivity:imgView];
                    if(imgView)
                    {
                        imgView.image = img;
                    }
                });
            }
            else
            {
                NSLog(@"不一致");
            }
        });
    }
}



-(void)addImgToImgViewFromDocumentORURL:(UIImageView*)imgView url:(NSString*)url
{
    NSString *document = [NSString stringWithFormat:@"%@/%@",CASH_DOCUMENT,CASH_IMGS];
    [self addImgToImgViewFromDocumentORURL:imgView document:document url:url];
}

-(void)saveImageWithUrl:(NSString *)url
{
    NSString *temImgName = [self liGetImgNameFromURL:url];
    if (temImgName) {
        UIImage *img = [self loadImagefromUrl:url];
        if (img) {
            dispatch_async(myIOQueue, ^(void){
                NSString *document = [NSString stringWithFormat:@"%@/%@",CASH_DOCUMENT,CASH_IMGS];
                NSString *temImgPath = [self getFilePath:temImgName directory:document];//NSLog(@"temimgpath:%@",temImgPath);
                if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath]){
                    UIImage *tmpImg = [self getImagefrompath:temImgPath];
                    if (![self compareImages:@[img,tmpImg]]) {
                        [self savepicturefromimage:img path:temImgPath];
                    }
                }else{
                    [self savepicturefromimage:img path:temImgPath];
                }
            });
        }
    }
}

-(BOOL)compareImages:(NSArray *)imgs
{
    BOOL result = NO;
    UIImage *img = imgs[0];
    UIImage *tmpImg = imgs[0];
    
    NSData *imgdata = UIImagePNGRepresentation(img);
    NSData *tmpimgdata = UIImagePNGRepresentation(tmpImg);
    
    if (strcmp([imgdata bytes], [tmpimgdata bytes]) == 0) result = YES;
    return result;
}

//avaudioplayer 播放音乐
-(void)playVoiceFromDocumentORURL:(AVAudioPlayer*)player url:(NSString*)url
{
    NSString *document = [NSString stringWithFormat:@"%@/%@",CASH_DOCUMENT,CASH_IMGS];
    [self playVoiceFromDocumentORURL:player document:document url:url];
}

-(void)playVoiceFromDocumentORURL:(AVAudioPlayer*)player document:(NSString*)document url:(NSString*)url
{
    NSString *temName = [self liGetImgNameFromURL:url];NSLog(@"temimgname:%@",temName);
    NSString *temPath = [self getFilePath:temName directory:document];
    
    NSLog(@"atempath:%@",temPath);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:temPath])
    {
        player = [player initWithContentsOfURL:[NSURL fileURLWithPath:temPath] error:nil];
        [player play];
    }
    else
    {
        NSURL *rurl = [[NSURL alloc]initWithString:url];
        NSData * audioData = [NSData dataWithContentsOfURL:rurl];
        
        
        //将数据保存到本地指定位置
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
        if([audioData writeToFile:filePath atomically:YES])
        {
            player = [player initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
            [player play];
        }
        else
        {
            NSLog(@"没保存成功");
        }
        //[audioData writeToFile:temPath atomically:YES];NSLog(@"tempath:%@",temPath);
        
        
        /*
         dispatch_async(myIOQueue, ^(void)
         {
         NSURL *rurl = [[NSURL alloc]initWithString:url];
         NSData * audioData = [NSData dataWithContentsOfURL:rurl];
         
         //将数据保存到本地指定位置
         [audioData writeToFile:temPath atomically:YES];
         
         dispatch_async(dispatch_get_main_queue(), ^(void){
         
         if(temPlayer)
         {
         temPlayer = [player initWithContentsOfURL:[NSURL fileURLWithPath:temPath] error:nil];
         [temPlayer play];
         
         
         }
         });
         
         });
         */
    }
}

#pragma mark- 文件相关

//获取缓存图片
- (UIImage*)getCashImageWithUrl:(NSString*)url
{
    UIImage *resultImg = nil;
    NSString *temImgName = [self liGetImgNameFromURL:url];
    if (temImgName) {
        NSString *document = [NSString stringWithFormat:@"%@/%@",CASH_DOCUMENT,CASH_IMGS];
        NSString *temImgPath = [self getFilePath:temImgName directory:document];
        if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
        {
            resultImg = [self getImagefrompath:temImgPath];
        }
    }
    
    return resultImg;
}

//获取系统cash文件夹
- (NSString*)getCashPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * path = [paths objectAtIndex:0];
    return path;
}

//获取文件完整路陉
-(NSString*)getFilePath:(NSString*)fileName
{
    NSString*path = [self getCashPath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];//NSLog(@"filePath:%@",filePath);
    return filePath;
}

//获取带文件夹的文件路径 例子：my/abc/img
-(NSString*)getFilePath:(NSString *)fileName directory:(NSString*)directoryName
{
    NSString*path = [self getCashPath];
    
    NSString *strPath = [path stringByAppendingPathComponent:directoryName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPath]) {
        NSLog(@"there is no Directory: %@",strPath);
        [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [path stringByAppendingFormat:@"/%@/%@",directoryName,fileName];
    return filePath;
}

//删除文件
-(BOOL)deleteFileAtPaths:(NSString *)path
{
    NSFileManager *manage=[NSFileManager defaultManager];
    BOOL flag=[manage removeItemAtPath:path error:nil];
    return flag;
}

//由图片的url生成图片名
-(NSString*)liGetImgNameFromURL:(NSString*)url
{
    if(![WFFunctions WFStrCheckEmpty:url])
    {
        NSString *imgName = [url stringByReplacingOccurrencesOfString:@"//" withString:@""];
        //NSLog(@"imganmea:%@",imgName);
        NSRange range = [imgName rangeOfString:@"/"];
        if(imgName.length > (range.location+range.length))
        {
            imgName = [imgName substringFromIndex:range.location+range.length];
            imgName = [imgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
            imgName = [imgName stringByReplacingOccurrencesOfString:@"." withString:@"@2x."];
            NSLog(@"img name:%@",imgName);
            
            return imgName;
        }
    }
    
    return nil;
}

//从文件获取图像
-(UIImage *)getImagefrompath:(NSString *)path
{
    return [UIImage imageWithContentsOfFile:path];
}

//下载网络上的图像
-(UIImage*)loadImagefromUrl:(NSString*)url
{
    UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return img;
}

//把图片存入本地
-(void)savepicturefromimage:(UIImage*)image path:(NSString *)path
{
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:WF_CASH_DONE_NOTIFICATION object:nil];
}

//往view添加等待菊花
-(void)addActivity:(UIView*)view
{
    UIActivityIndicatorView *topImgActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    topImgActivity.hidesWhenStopped=YES;
    [view addSubview:topImgActivity];
    
    topImgActivity.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    [topImgActivity startAnimating];
}

//关闭等待菊花
-(void)stopActivity:(UIView*)view
{
    for(UIView *subView in view.subviews)
    {
        if([subView isKindOfClass:[UIActivityIndicatorView class]])
        {
            UIActivityIndicatorView *temActivity = (UIActivityIndicatorView*)subView;
            [temActivity stopAnimating];
        }
    }
}


#pragma mark- Singleton Methods
+ (id)sharedManager
{
    
    @synchronized(self)
    {
        if(sharedCashManager == nil)
            sharedCashManager = [[super allocWithZone:NULL] init];
        
    }
    return sharedCashManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        myIOQueue = dispatch_queue_create("cash.io.queue", nil);
    }
    return self;
}
@end
