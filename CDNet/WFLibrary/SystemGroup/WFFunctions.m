//
//  WFFunctions.m
//  WFFrameWorkDeal
//
//  Created by 海莱 on 15/7/2.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import "WFFunctions.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation WFFunctions
#pragma mark - 字符串相关
//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)WFStrGetFirstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}
//函数功能：字符串判空
+(Boolean) WFStrCheckEmpty:(NSString *)p_str
{
    if (!p_str)
    {
        return YES;
    }
    if ([p_str isEqual:nil])
    {
        return YES;
    }
    if ([p_str isEqual:@""])
    {
        return YES;
    }
    if([p_str isEqual:@"(null)"])
    {
        return YES;
    }
    if([p_str isEqual:@"<null>"])
    {
        return YES;
    }
    
    id tempStr=p_str;
    if (tempStr==[NSNull null])
    {
        return YES;
    }
    return NO;
}

//过滤空数据
+ (NSString*)WFStrGetFromStr:(NSString*)p_str
{
    if(![WFFunctions WFStrCheckEmpty:p_str])
    {
        return p_str;
    }
    else
    {
        return @"";
    }
}

//判断字符串是否包含某个字符
+ (BOOL)WFStrContent:(NSString*)p_str inString:(NSString*)p_pStr
{
    NSRange range = [p_pStr rangeOfString:p_str];//判断字符串是否包含
    
    if (range.length >0)//包含
    {
        return YES;
    }
    else//不包含
    {
        return NO;
    }
}

//获取文字大小
+ (CGSize)WFStrGetSize:(NSString*)str width:(float)width font:(UIFont*)font
{
    CGSize temSize = CGSizeZero;
    if(![WFFunctions WFStrCheckEmpty:str])
    {
        
        NSDictionary *attribute = @{NSFontAttributeName:font};
        
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        
        temSize = rect.size;
    }
    return temSize;
}

+ (CGRect)WFStrGetSize:(NSAttributedString*)astr width:(float)width
{
    CGRect rect = CGRectZero;
    if (astr) {
        rect = [astr boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    }
    return rect;
}

+ (CGRect)WFStrGetRect:(NSString*)str width:(CGFloat)width
{
    CGRect rect = CGRectZero;
    if(![WFFunctions WFStrCheckEmpty:str])
    {
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        rect = [attrStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    }
    return rect;
}

+ (BOOL)WFStrIsMobileNumber:(NSString *)mobileNum
{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    MOBILE = @"^1[3|4|5|7|8][0-9]\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    //NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    NSString * PHS = @"^0\\d{2,3}-\\d{5,9}|0\\d{2,3}-\\d{5,9}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES)|| ([regextestct evaluateWithObject:mobileNum] == YES)|| ([regextestphs evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    
    if (mobileNum) {
        if (mobileNum.length == 11) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)WFStrIsEmail:(NSString*)email
{
    NSString *regex = @"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:email];
}

+ (BOOL)WFStrIsMoney:(NSString*)money
{
    NSString *regex = @"^[0-9]*\\.?[0-9]{0,2}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:money];
}

+ (BOOL)WFStrIsPWD:(NSString*)p_pwd
{
    NSString *regex = @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).{4,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:p_pwd];
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (NSData *)WFToJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+ (NSDictionary *)WFDictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (NSString*)WFConvertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

#pragma mark - 时间相关

+ (NSDate*)WFTimeGetNowDate
{
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    date = localeDate;
    
    return date;
}

+ (NSString*)WFTimeGetNowStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString*)WFTimeGetStringFromDate:(NSDate*)p_date byFormatter:(NSString*)p_formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:p_formatter];
    NSString *string = [dateFormatter stringFromDate:p_date];
    return string;
}


///获取时间差
+ (CGFloat)WFGetDateDifference:(NSString*)oldDateStr newDate:(NSString*)newDateStr
{
    CGFloat timeDifference = 0.0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [formatter dateFromString:oldDateStr];
    NSDate *newDate = [formatter dateFromString:newDateStr];
    NSTimeInterval oldTime = [oldDate timeIntervalSince1970];
    NSTimeInterval newTime = [newDate timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}
//列表里显示日期
+(NSString *)WFTimeGetTimeFromDate:(NSString *)fromDate
{
    if([WFFunctions WFStrCheckEmpty:fromDate])
    {
        return @"";
    }
    
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:fromDate];
    
    NSString *nowdate = [WFFunctions WFTimeGetNowStr];
    NSRange temRange = NSMakeRange(0, 10);
    NSString *timeStrNow = [nowdate substringWithRange:temRange];
    NSString *timeStrOld = [fromDate substringWithRange:temRange];
    
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags=NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent=[calendar components:unitFlags fromDate:oldDate toDate:date options:0];
    
    //NSInteger difMonth=[dateComponent month];
    //NSInteger difDay=[dateComponent day];
    NSInteger difHour=[dateComponent hour];
    NSInteger diffMin=[dateComponent minute];
    NSString *timer = nil;
    if ([timeStrNow isEqualToString:timeStrOld])//当天的
    {
        if (difHour == 0)//不到一个小时
        {
            if (diffMin <= 5)//不到五分钟
                timer=[NSString stringWithFormat:@"刚刚"];
            else
                timer=[NSString stringWithFormat:@"%ld分钟前",(long)diffMin];
        }else
            timer=[NSString stringWithFormat:@"今天%@",[fromDate substringWithRange:NSMakeRange(11, 5)]];
        
    }else
    {
        temRange = NSMakeRange(0, 4);
        timeStrNow = [nowdate substringWithRange:temRange];
        timeStrOld = [fromDate substringWithRange:temRange];
        if ([timeStrNow isEqualToString:timeStrOld])//今年的
            timer=[NSString stringWithFormat:@"%@",[fromDate substringWithRange:NSMakeRange(5, 11)]];
        else
            timer=[NSString stringWithFormat:@"%@",[fromDate substringWithRange:NSMakeRange(0, 10)]];
    }
    return timer;
}

//获取天数
+(NSInteger)WFTimeGetDifDayStartDate:(NSString *)p_startDate endDate:(NSString*)p_endDate
{
    if([WFFunctions WFStrCheckEmpty:p_startDate]||[WFFunctions WFStrCheckEmpty:p_endDate])
    {
        return -1;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:p_startDate];
    NSDate *endDate = [dateFormatter dateFromString:p_endDate];
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    NSInteger day = 0;
    
    if(timeInterval>=0)
    {
        //如果大于0剩余
        day = timeInterval/(3600*24);
        NSInteger second = timeInterval - day*3600*24;
        
        NSInteger oriHour = [[p_startDate substringWithRange:NSMakeRange(11, 2)]integerValue];
        NSInteger oriMin = [[p_startDate substringWithRange:NSMakeRange(14, 2)]integerValue];
        NSInteger oriSec = [[p_startDate substringWithRange:NSMakeRange(17, 2)]integerValue];
        NSUInteger ori = oriHour*3600+oriMin*60+oriSec;//NSLog(@"oria:%d",ori);
        
        //超过24小时补偿1天
        NSInteger dif = (second+ori)/(3600*24);
        day = day + dif;
    }
    else
    {
        //超期
        timeInterval = -timeInterval;//NSLog(@"aastart:%@  endda:%@",p_startDate,p_endDate);
        day = timeInterval/(3600*24);//NSLog(@"aday:%d",day);
        NSInteger second = timeInterval - day*3600*24;//NSLog(@"asec:%d",second);
        
        NSInteger oriHour = [[p_endDate substringWithRange:NSMakeRange(11, 2)]integerValue];
        NSInteger oriMin = [[p_endDate substringWithRange:NSMakeRange(14, 2)]integerValue];
        NSInteger oriSec = [[p_endDate substringWithRange:NSMakeRange(17, 2)]integerValue];
        NSUInteger ori = oriHour*3600+oriMin*60+oriSec;//NSLog(@"oria:%d",ori);
        
        NSInteger dif = (ori+second)/(3600*24);//NSLog(@"adif:%d",dif);
        day = day + dif;
        day = -day;
        
    }
    
    return day;
}

//获取分钟数
+(NSInteger)WFTimeGetDifMinStartDate:(NSString *)p_startDate endDate:(NSString*)p_endDate
{
    if([WFFunctions WFStrCheckEmpty:p_startDate]||[WFFunctions WFStrCheckEmpty:p_endDate])
    {
        return -1;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:p_startDate];
    NSDate *endDate = [dateFormatter dateFromString:p_endDate];
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    NSInteger min = 0;
    
    min = timeInterval/60;
    
    return min;
}
+ (NSString *)WFTimeGetStringToDate:(NSString *)toDate
{
    NSString *dateContent = @"大于十天";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:toDate];
    
    if (newsDateFormatted) {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        
        NSDate* current_date = [[NSDate alloc] init];
        
        NSTimeInterval time=[newsDateFormatted timeIntervalSinceDate:current_date];//间隔的秒数
        
        if (time >= 0) {
            //    int month=((int)time)/(3600*24*30);
            int days=((int)time)/(3600*24);
            int hours=((int)time)%(3600*24)/3600;
            int minute=((int)time)%(3600*24)/60;
            int second = ((int)time)%(3600*24)%60;
            dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
            
            if (days > 10) {
                dateContent = @"大于十天";
            }else{
                if (days == 0 && hours == 0) {
                    dateContent=[[NSString alloc] initWithFormat:@"%i分%i秒",minute,second];
                }
            }
            
        }else{
            dateContent = @"优惠结束";
        }
    }
    
    return dateContent;
}
+ (NSDictionary *)WFTimeGetTimesToDate:(NSString *)toDate
{
    NSDictionary *timeInfo = @{};
    NSString *daystr = @"0";
    NSString *hourstr = @"0";
    NSString *minutestr = @"0";
    NSString *secondstr = @"0";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:toDate];
    
    if (newsDateFormatted) {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        
        NSDate* current_date = [[NSDate alloc] init];
        
        NSTimeInterval time = [newsDateFormatted timeIntervalSinceDate:current_date];//间隔的秒数
        
        if (time >= 0) {
            int days=((int)time)/(3600*24);
            int hours=((int)time)%(3600*24)/3600;
            int minute=((int)time)%(3600*24)%3600/60;
            int second = ((int)time)%(3600*24)%3600%60;
            
            daystr = [NSString stringWithFormat:@"%d",days];
            hourstr = [NSString stringWithFormat:@"%d",hours];
            minutestr = [NSString stringWithFormat:@"%d",minute];
            secondstr = [NSString stringWithFormat:@"%d",second];
            
            timeInfo = @{@"day":daystr,@"hour":hourstr,@"minute":minutestr,@"second":secondstr};
            
        }else{
            daystr = @"0";
            hourstr = @"0";
            minutestr = @"0";
            secondstr = @"0";
            
            timeInfo = @{@"day":daystr,@"hour":hourstr,@"minute":minutestr,@"second":secondstr};
        }
    }
    
    return timeInfo;
}
///按照格式返回时间字符
+ (NSString *)WFTimeGetString:(NSDate *)date byFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}
#pragma mark - 视图相关

//描边
+ (BOOL)WFUIaddBorderToView:(UIView*)p_view
{
    return [WFFunctions WFUIaddbordertoView:p_view radius:5 width:0.5 color:[UIColor whiteColor]];
}

+ (BOOL)WFUIaddbordertoView:(UIView*)view radius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color
{
    CALayer *layer = [view layer];
    [layer setBorderColor:color.CGColor];
    [layer setBorderWidth:width];
    [layer setCornerRadius:radius];
    [layer setMasksToBounds:YES];
    return YES;
}

///根据圆角、宽度和颜色描虚线
+ (BOOL)WFUIadddashtoView:(UIView*)view radius:(CGFloat)radius width:(CGFloat)width dashPattern:(CGFloat)dashPattern spacePattern:(CGFloat)spacePattern color:(UIColor*)color borderType:(BorderType)type
{
    //border definitions
    CGFloat cornerRadius = radius;
    CGFloat borderWidth = width;
    NSInteger dashPattern1 = dashPattern;
    NSInteger dashPattern2 = spacePattern;
    UIColor *lineColor = color ? color : [UIColor blackColor];
    BorderType btype = type ?: BorderTypeDashed;
    //drawing
    CGRect frame = view.bounds;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = btype == BorderTypeDashed ? [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)dashPattern1], [NSNumber numberWithInt:(int)dashPattern2], nil] : nil;
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [view.layer addSublayer:_shapeLayer];
    view.layer.cornerRadius = cornerRadius;
    return YES;
}

+ (void)WFUIaddBorderToView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width {
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    } if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    } if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    } if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

+ (BOOL)WFUIMakeRadiusWithView:(UIView*)p_view
{
    CALayer *layer = [p_view layer];
    [layer setBorderColor:[UIColor clearColor].CGColor];
    [layer setBorderWidth:0.];
    [layer setCornerRadius:p_view.frame.size.width/2];
    [layer setMasksToBounds:YES];
    
    return YES;
}

//给view 添加动画
+(void)WFUIBeginAnimations:(NSTimeInterval)duration view:(UIView*)view withHandler:(void(^)(UIView * temView))block
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:view cache:NO];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:nil];
    block(view);
    [UIView commitAnimations];
}

//#pragma mark 图片相关
//等比缩放
+ (UIImage *)WFUIScaleImage:(UIImage *)image toScale:(float)scale

{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scale, image.size.height*scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width*scale, image.size.height*scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//拍照或者从相册获取图片结束后裁剪图片
+(UIImage*)WFUIGetImage:(UIImage*)image
{
    CGFloat scale = image.size.width>image.size.height?640/image.size.width:640/image.size.height;
    UIImage *temImg = image;
    if(scale < 1)
    {
        temImg = [WFFunctions WFUIScaleImage:image toScale:scale];
    }
    return temImg;
}
//添加上下黑边的方法
+(UIImage*)WFUIImageToSquare:(UIImage*)image
{
    if(image.size.width <= image.size.height)
    {
        return image;
    }
    CGSize contentSize = CGSizeMake(image.size.width, image.size.width);
    CGFloat yCoordinate = (contentSize.height-image.size.height)/2;NSLog(@"y:%f",yCoordinate);
    
    //初始化画布
    UIGraphicsBeginImageContext(contentSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, contentSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //fill color
    CGColorRef fillColor = [[UIColor clearColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, contentSize.height);
    CGContextAddLineToPoint(context, 0.0f, contentSize.height);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    //画图
    CGContextDrawImage(context, CGRectMake(0.0, yCoordinate, contentSize.width, image.size.height), image.CGImage);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

///从颜色创建图片
+ (UIImage *)WFUICreateImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

//通过view获取cell
+ (UITableViewCell*)WFUIGetCellFromView:(UIView*)sender
{
    UITableViewCell *cell = nil;
    for(UIView*view = sender;view;view = view.superview)
    {
        if([view isKindOfClass:[UITableViewCell class]])
        {
            return (UITableViewCell*)view;
        }
    }
    
    return cell;
}

+ (UICollectionViewCell*)WFUIGetCollectionCellFromView:(UIView*)sender
{
    UICollectionViewCell *cell = nil;
    for(UIView*view = sender;view;view = view.superview)
    {
        if([view isKindOfClass:[UICollectionViewCell class]])
        {
            return (UICollectionViewCell*)view;
        }
    }
    
    return cell;
}

//隐藏tabBar
+ (BOOL)WFHideTabBar:(UITabBarController *) tabbarcontroller duration:(NSTimeInterval)duration
{
    /*
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:duration];
     for(UIView *view in tabbarcontroller.view.subviews)
     {
     if([view isKindOfClass:[UITabBar class]])
     {
     [view setFrame:CGRectMake(view.frame.origin.x, GY_UI_ViewHeight+64, view.frame.size.width, view.frame.size.height)];
     }
     else
     {
     [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, GY_UI_ViewHeight+64)];
     }
     }
     [UIView commitAnimations];
     */
    return YES;
    
}

//显示tabBar
+ (BOOL)WFShowTabBar:(UITabBarController *) tabbarcontroller duration:(NSTimeInterval)duration
{
    /*
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:duration];
     for(UIView *view in tabbarcontroller.view.subviews)
     {
     if([view isKindOfClass:[UITabBar class]])
     {
     [view setFrame:CGRectMake(view.frame.origin.x, (GY_UI_ViewHeight+64-49), view.frame.size.width, view.frame.size.height)];
     }
     else
     {
     [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,(GY_UI_ViewHeight+64-49))];
     }
     }
     
     [UIView commitAnimations];
     */
    return YES;
}



#pragma mark - 系统相关

//获取mac地址
+ (NSString *)WFSysGetMacaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
    
}

//获取idfa
+(NSString*)WFSysGetIdfa
{
    //return  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return @"";
}
///获取应用版本号
+ (NSString*)WFSysGetAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}

// 寻找第一响应者
+ (id)WFSysGettraverseResponder:(UIView*)view
{
    for(id next = [view nextResponder];true;next = [next nextResponder])
    {
        if([next isKindOfClass:[UIViewController class]])
        {
            return next;
        }
    }
    
    return nil;
}

// 寻找UITableviewCell
+ (UITableViewCell*)WFSysGetCellFromView:(UIView*)paraView
{
    UITableViewCell *cell = nil;
    
    for(UIView *view = paraView ;view;view = view.superview)
    {
        if([view isKindOfClass:[UITableViewCell class]])
        {
            cell = (UITableViewCell*)view;
            break;
        }
    }
    
    return cell;
}
///为键盘添加完成按钮
+(void)WFSysddFinishButtonForText:(id)sender withSelector:(SEL)selector andTarget:(id)target
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 50)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"完成" forState:UIControlStateNormal];
    [btn2 addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    toolBar.items = @[/*prevButton, nextButton,*/ space, done];
    
    [sender performSelector:@selector(setInputAccessoryView:) withObject:toolBar];
}
///获得urlquery字典信息
+ (NSDictionary*)WFGetDictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}
///一个alert动画
+ (void)WFExChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
}
///一个push动画
+ (void)WFPusht:(UIView *)changeOutView dur:(CFTimeInterval)dur
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.3f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromRight;
    
    transition.delegate = self;
    
    [changeOutView.layer addAnimation:transition forKey:nil];
}
///一个pop动画
+ (void)WFPop:(UIView *)changeOutView dur:(CFTimeInterval)dur
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.3f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromLeft;
    
    transition.delegate = self;
    
    [changeOutView.layer addAnimation:transition forKey:nil];
}
///传说中的touchid
+ (void)authenticateUserWithCallBack:(void (^)(NSDictionary *info,NSError *error))handler
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"Authentication is needed to access your notes.";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                handler(@{@"result":@"success"},error);
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            handler(@{@"result":@"password"},error);
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            handler(@{@"result":@"other"},error);
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
        handler(@{@"result":@"unsupport"},error);
    }
}
//从十六进制字符串获取颜色 color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)WFColorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}
@end
