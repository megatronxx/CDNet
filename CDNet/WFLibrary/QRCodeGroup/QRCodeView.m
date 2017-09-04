//
//  QRCodeView.m
//  ZGHMS
//
//  Created by HaiLai on 15/12/17.
//  Copyright © 2015年 海莱. All rights reserved.
//

#import "QRCodeView.h"
#import "WFHead.h"

static NSString *QRCodeKey;

@interface QRCodeView ()<AVCaptureMetadataOutputObjectsDelegate>
{
    ///计数
    CGFloat num;
    ///可否滚动
    BOOL upOrdown;
}
///计时器
@property (nonatomic,strong) NSTimer *timer;
///滚动的线条
@property (nonatomic,strong) UIImageView *scanLine;
///设备
@property (nonatomic,strong) AVCaptureDevice *device;
///输入
@property (nonatomic,strong) AVCaptureDeviceInput *input;
///输出
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
///对话
@property (nonatomic,strong) AVCaptureSession *session;
///扫码区域
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;
@end

@implementation QRCodeView
@synthesize timer,scanLine,device,input,output,session,preview;
#pragma mark - 事件

#pragma mark - 方法
-(void)initilization
{
    session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        NSError *err;
        //扫码输入
        input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&err];
        if (!err) {
            [session addInput:input];
            
            //扫码输出
            output = [[AVCaptureMetadataOutput alloc]init];
            [session addOutput:output];
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            NSLog(@"支持的扫描类型：%@",output.availableMetadataObjectTypes);
            output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
            output.rectOfInterest = CGRectMake((WF_UI_VIEW_HEIGHT / 2 - 110) / WF_UI_VIEW_HEIGHT,(WF_UI_VIEW_WIDTH / 2 - 110) / WF_UI_VIEW_WIDTH,220/WF_UI_VIEW_HEIGHT,220/WF_UI_VIEW_WIDTH);
        
            //扫码场景
            preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
            preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            preview.frame = [[UIScreen mainScreen]bounds];
            [self.layer addSublayer:preview];
            
            //背景
            UIImageView *containIV = [[UIImageView alloc]init];
            CGRect rect = CGRectMake(WF_UI_VIEW_WIDTH / 2 - 110,WF_UI_VIEW_HEIGHT / 2 - 110,220,220);
            containIV.frame = rect;
            containIV.image = [UIImage imageNamed:@"pick_bg"];
            [self addSubview:containIV];
            
            //扫描线
            scanLine = [[UIImageView alloc]initWithFrame:CGRectMake(WF_UI_VIEW_WIDTH / 2 - 110,WF_UI_VIEW_HEIGHT / 2 - 110,220,2)];
            scanLine.image = [UIImage imageNamed:@"line"];
            [self addSubview:scanLine];
            
            //定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animate) userInfo:nil repeats:YES];
            
        }else{
            NSLog(@"创建输入出错：%@",err);
            NSError *err = [NSError errorWithDomain:@"扫码出错" code:1024 userInfo:nil];
            QRScanHandler handler = objc_getAssociatedObject(self, &QRCodeKey);
            handler(nil,err);
            [session stopRunning];
        }
    }
}
-(void)animate
{
    if (upOrdown){
        num = num + 1.0f;
        CGFloat move = num * 2;
        scanLine.frame = CGRectMake(WF_UI_VIEW_WIDTH / 2 - 110, WF_UI_VIEW_HEIGHT / 2 - 110 + move, 220, 2);
        if (2*num >= 220.0f) {
            upOrdown = NO;
        }
    }else{
        num = num - 1.0f;
        CGFloat move = num * 2;
        scanLine.frame = CGRectMake(WF_UI_VIEW_WIDTH / 2 - 110, WF_UI_VIEW_HEIGHT / 2 - 110 + move, 220, 2);
        if (num <= 0.0f) {
            upOrdown = YES;
        }
    }
}
-(instancetype)initWithHandler:(QRScanHandler)handler
{
    if (self = [super init]) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &QRCodeKey, handler, OBJC_ASSOCIATION_COPY);
        [self initilization];
    }
    return self;
}
-(void)startScan
{
    if (session != nil) {
        [session startRunning];
    }
}
+(UIImage *)createQRForString:(NSString *)qrString andQrImageName:(NSString *)qrImageName
{
    NSString *sureQRString = qrString;
    NSData *stringData = [sureQRString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    // 创建一个二维码的滤镜
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrCIImage = qrFilter.outputImage;
    // 创建一个颜色滤镜,黑白色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setDefaults];
    [colorFilter setValue:qrCIImage forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor1"];
    // 返回二维码image
    UIImage *codeImage = [UIImage imageWithCIImage:[colorFilter.outputImage imageByApplyingTransform:CGAffineTransformMakeScale(5, 5)]];
    codeImage = [QRCodeView createNonInterpolatedUIImageFormCIImage:qrFilter.outputImage withSize:200];
    // 通常,二维码都是定制的,中间都会放想要表达意思的图片
    UIImage *iconImage = [UIImage imageNamed:qrImageName];
    if (iconImage){
        CGRect rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height);
        UIGraphicsBeginImageContext(rect.size);
        
        [codeImage drawInRect:rect];
        CGSize avatarSize = CGSizeMake(rect.size.width * 0.25, rect.size.height * 0.25);
        CGFloat x = (rect.size.width - avatarSize.width) * 0.5;
        CGFloat y = (rect.size.height - avatarSize.height) * 0.5;
        [iconImage drawInRect:CGRectMake(x, y, avatarSize.width, avatarSize.height)];
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return resultImage;
    }
    return codeImage;
}
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - 生命周期
-(void)dealloc
{
    [timer invalidate];
    [session stopRunning];
    [preview removeFromSuperlayer];
    [output setMetadataObjectsDelegate:nil queue:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - delegate
#pragma mark - acputure out put delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *val;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)metadataObjects[0];
        val = [obj stringValue];
        
        NSDictionary *dic = @{@"QRCodeContent":val};
        QRScanHandler handler = objc_getAssociatedObject(self, &QRCodeKey);
        handler(dic,nil);
        [session stopRunning];
    }
}
@end
