//
//  NSString+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "NSString+XGAdd.h"
#import <sys/sysctl.h>
#import <sys/utsname.h>

@implementation NSString (XGAdd)

/* 获得设备版本号 */
+ (NSString *)getDeviceVersion {
    size_t size;
    sysctlbyname("hw.machine",NULL, &size, NULL,0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size,NULL, 0);
    NSString *deviceVersion = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([deviceVersion isEqualToString:@"iPhone Simulator"] ||
        [deviceVersion isEqualToString:@"x86_64"] ||
        [deviceVersion isEqualToString:@"i386"]) {
        deviceVersion = @"Simulator";
    }
    return deviceVersion;
}

/* 获得当前时间戳 */
+ (NSTimeInterval)getLocolTimeinterval {
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    return time * 1000;
}

/* 用当前时区返回时间 */
+ (NSDate *)localDateWithDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    return localeDate;
}

/* 精细时间显示规则:
 (1）小于一分钟：一分钟前；
 (2）大于等于一分钟、小于一小时：X分钟前；
 (3）大于一小时、小于24小时：X小时前
 (4）大于24小时，小于48小时：昨天；
 (5）大于等于48小时：年-月-日（xxxx-xx-xx） */
+ (NSString *)getFineTimeDisplay:(NSInteger)timeStamp {
    if (timeStamp <= 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000];/* 获取北京时间 */
    //得到与当前时间差
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    long temp = 0;
    NSString *result = nil;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"一分钟前"];
    } else if ((temp = timeInterval / 60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    } else if ((temp = timeInterval / 3600) > 1 && (temp = timeInterval / 3600) < 24) {
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    } else if ((temp = timeInterval / 3600) > 24 && (temp = timeInterval / 3600) < 48){
        result = @"昨天";
    } else {
        result = [formatter stringFromDate:date];
    }
    return result;
}


/* 获得当前设备型号 */
+ (NSString *)getDeviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    //------------------------------iPhone---------------------------
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"] ||
        [platform isEqualToString:@"iPhone3,2"] ||
        [platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"] ||
        [platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"] ||
        [platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"] ||
        [platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"] ||
        [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"] ||
        [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"] ||
        [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"] ||
        [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"] ||
        [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"] ||
        [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    //------------------------------iPad--------------------------
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"] ||
        [platform isEqualToString:@"iPad2,2"] ||
        [platform isEqualToString:@"iPad2,3"] ||
        [platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"] ||
        [platform isEqualToString:@"iPad3,2"] ||
        [platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"] ||
        [platform isEqualToString:@"iPad3,5"] ||
        [platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"] ||
        [platform isEqualToString:@"iPad4,2"] ||
        [platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"] ||
        [platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"] ||
        [platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
    if ([platform isEqualToString:@"iPad6,7"] ||
        [platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
    if ([platform isEqualToString:@"iPad6,11"] ||
        [platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,1"] ||
        [platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([platform isEqualToString:@"iPad7,3"] ||
        [platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    
    //------------------------------iPad Mini-----------------------
    if ([platform isEqualToString:@"iPad2,5"] ||
        [platform isEqualToString:@"iPad2,6"] ||
        [platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad4,4"] ||
        [platform isEqualToString:@"iPad4,5"] ||
        [platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"] ||
        [platform isEqualToString:@"iPad4,8"] ||
        [platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,1"] ||
        [platform isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    
    //------------------------------iTouch------------------------
    if ([platform isEqualToString:@"iPod1,1"]) return @"iTouch";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iTouch2";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iTouch3";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iTouch4";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iTouch5";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iTouch6";
    
    //------------------------------Samulitor-------------------------------------
    if ([platform isEqualToString:@"i386"] ||
        [platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return @"Unknown";
}

/* 时间显示规则: 当天:(HH:mm) 昨天:(昨天 HH:mm) 隔天:(月[月] 日[日] HH:mm) 跨年:(年[年] 月[月] 日[日] HH:mm) */
+ (NSString *)getTimeDisplay:(NSInteger)timeStamp {
    if (timeStamp <= 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000];/* 获取北京时间 */
    NSDate *localDate = [self localDateWithDate:date];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    today = [self localDateWithDate:today];
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *dateString = [[localDate description] substringToIndex:10];
    if ([dateString isEqualToString:todayString]) {/* 今天 */
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:date];
    } else if ([dateString isEqualToString:yesterdayString]) {/* 昨天 */
        [formatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@" ,[formatter stringFromDate:date]];
    } else {/* 今年之内 */
        [formatter setDateFormat:@"YYYY"];
        NSString *thisYearString = [formatter stringFromDate:today];
        NSString *yearString = [formatter stringFromDate:date];
        if ([thisYearString isEqualToString:yearString]) {/* 今年 */
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
        } else {/* 跨年 */
            [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
        }
        return [formatter stringFromDate:date];
    }
}

/* 字母、数字、中文等正则判断（不包括空格） */
+ (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=str.length;
        for(int i=0;i<len;i++) {
            unichar a=[str characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:str].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
    }
    return isMatch;
}

/// 将目标时间戳转成当前时区的时间戳
+ (NSDate *)getYearMonthDay:(long long)timeStamp {
    if (timeStamp <= 0) {
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000];
    NSDate *localDate = [self localDateWithDate:date];
    return localDate;
}

/// 判断当前时间是否在目标时间范围内
+ (BOOL)judgeTimeByStartAndEnd:(long long)startTimeStamp withExpireTime:(long long)expireTimeStamp {
    /** 获取当前时间 */
    NSDate *currentTimeDate = [[NSDate alloc] init];
    currentTimeDate = [self localDateWithDate:currentTimeDate];
    NSTimeInterval currentTime = currentTimeDate.timeIntervalSince1970;
    
    /** 获取开始时间 */
    NSTimeInterval startTime = [self getYearMonthDay:startTimeStamp].timeIntervalSince1970;
    
    /** 获取结束时间 */
    NSTimeInterval expireTime = [self getYearMonthDay:expireTimeStamp].timeIntervalSince1970;
    
    if (currentTime > startTime && currentTime < expireTime) {
        return YES;
    }
    return NO;
}

/* 字母、数字、中文正则判断（包括空格） */
+ (BOOL)isInputRuleAndBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:str];
}

/* 字母、数字、正则判断（不包括空格） */
+ (BOOL)isInputRuleNotBlankAndChinese:(NSString *)str {
    NSString *pattern = @"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:str];
}

/* 中文、字母的正则判断 */
+ (BOOL)isInputChineseAndLetter:(NSString *)string {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:string];
}

/* 中文的正则判断 */
+ (BOOL)isInputChinese:(NSString *)string {
    NSString *pattern = @"^[\u4E00-\u9FA5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:string];
}

/* 数字的正则判断 */
+ (BOOL)isInputNumber:(NSString *)string {
    NSString *pattern = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:string];
}

/* 过滤字符串中的emoji */
+ (NSString *)disable_emoji:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

/* 判断是否有emoji */
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                        // Not surrogate pair (U+2100-27BF)
                                    } else {
                                        if (0x2100 <= high && high <= 0x27BF){
                                            returnValue = YES;
                                        }
                                    }
                                }
                            }];
    return returnValue;
}

/* 将汉字转换为拼音 */
+ (NSString *)transform:(NSString *)chinese {
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    //去除掉首尾的空白字符和换行字符
    NSString *pinYinStr = nil;
    pinYinStr = [pinyin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除掉其它位置的空白字符和换行字符
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [pinYinStr capitalizedString];
    return pinYinStr;
}

/* 将汉字转成拼音字符串或者首字母 */
+ (NSString *)transformToPinyin:(NSString *)chinese {
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSArray *pinyinArray = [pinyin componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString string];
    /**< 拼音搜索 */
    int count = 0;
    for (int i = 0; i < pinyinArray.count; i++) {
        for (int i = 0; pinyinArray.count; i++) {
            if (i == count) {
                [allString appendString:@"#"];/**< 区分第几个字母 */
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
        }
        [allString appendString:@","];
        count++;
    }
    /**< 首字母搜索 */
    NSMutableString *initialString = [NSMutableString string];
    for (NSString *string in pinyinArray) {
        if (string.length > 0) {
            [initialString appendString:[string substringToIndex:1]];
        }
    }
    [allString appendFormat:@"#%@",initialString];
    [allString appendFormat:@"#%@",pinyin];
    return allString;
}

/* 提取每个汉字拼音的首字母(大写) */
+ (NSString *)transformToInitial:(NSString *)chinese {
    NSString *pinyin = [self transform:chinese];
    NSString *initialString = [pinyin substringToIndex:1];
    return [initialString uppercaseString];
}

/* 身份证验证 */
+ (BOOL)isIdentityCard:(NSString *)IDCardNumber {
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

/* 过滤字符串中的HTML标签 */
+ (NSString *)flattenHTML:(NSString *)html {
    html = [self htmlEntityDecode:html];
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}

//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"nbsp;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];// Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    string = [string stringByReplacingOccurrencesOfString:@"mdash;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@""];
    return string;
}

/* 去掉小数位后面的0 */
+ (NSString *)removeZerosAfterTheDecimalPoint:(NSString *)number {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler  decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                              scale:2
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    decimalNumber = [decimalNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return decimalNumber.description;
}

/* 判断url是否合法 */
+ (NSString *)getCompleteWebsite:(NSString *)urlStr{
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    assert(urlStr != nil);
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (urlStr != nil && urlStr.length != 0) {
        NSRange urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            assert(scheme != nil);
            if ( ([scheme compare:@"http" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                //不支持的URL方案
            }
        }
    }
    return returnUrlStr;
}

//验证手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    NSString * mobile = @"^1\\d{10}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    if ([regextestMobile evaluateWithObject:mobileNum] == YES) {
        return YES;
    } else {
        return NO;
    }
}

/** 判断是否全是空格 */
+ (BOOL)isEmpty:(NSString *)string {
    if (!string) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        return trimedString.length == 0;
    }
}

/** JSON字符串转化为字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        XLog(@"json解析失败：%@",error);
        return nil;
    }
    return dict;
}

/// 将操过10000的数字类型转成中文万
+ (NSString *)convertTheNumberWanToChineseWan:(NSString *)numberWan {
    NSString *numberString = numberWan;
    if (numberWan.floatValue >= 10000) {
        NSDecimalNumber *priceNumber = [NSDecimalNumber decimalNumberWithString:numberWan];
        NSDecimalNumber *houseSizeNumber = [NSDecimalNumber decimalNumberWithString:@(10000).stringValue];
        NSDecimalNumber *totalNumber = [priceNumber decimalNumberByDividingBy:houseSizeNumber];
        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler  decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                  scale:2
                                                                                       raiseOnExactness:NO
                                                                                        raiseOnOverflow:NO
                                                                                       raiseOnUnderflow:NO
                                                                                    raiseOnDivideByZero:NO];
        totalNumber = [totalNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
        numberString = [NSString stringWithFormat:@"%@万", totalNumber.description];
    }
    return numberString;
}

@end
