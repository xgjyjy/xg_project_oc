//
//  XGMatchManager.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGMatchManager.h"

@implementation XGMatchManager

/// 整数和小数的正则判断
/// @param integerDigits 整数位数
/// @param decimalPlaces 小数位数
/// @param matchString 需要判断的字符串
+ (BOOL)matchIntegers:(NSInteger)integerDigits decimals:(NSInteger)decimalPlaces matchString:(NSString *)matchString {
    // 匹配以0开头的数字
    BOOL isZero = ![self matchRegular:@"^[0][0-9]+$" matchString:matchString];
    // 匹配两位小数、整数
    BOOL isCorrectValue = [self matchRegular:[NSString stringWithFormat:@"^\\d{0,%@}$|^(\\d{0,%@}[.][0-9]{0,%@})$", @(integerDigits), @(integerDigits), @(decimalPlaces)] matchString:matchString];
    return isZero && isCorrectValue;
}

/// 字母、数字、中文正则判断（不包括空格）
/// 在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
/// @param string 需要判断的字符串
+ (BOOL)isLettersOrNumbersOrChinese:(NSString *)string {
    BOOL isMatch = [self matchRegular:@"^[a-zA-Z\u4E00-\u9FA5\\d]*$" matchString:string];
    if (!isMatch) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len = string.length;
        for(int i = 0;i < len;i++) {
            unichar a = [string characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 //                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:string].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
    }
    return isMatch;
}

/// 字母、数字、正则判断（不包括空格）
/// @param string 需要判断的字符串
+ (BOOL)isLettersOrNumbers:(NSString *)string {
    return [self matchRegular:@"[a-zA-Z0-9]*" matchString:string];
}

/// 数字的正则判断（不包括空格）
/// @param string 需要判断的字符串
+ (BOOL)isNumbers:(NSString *)string {
    return [self matchRegular:@"[0-9]*" matchString:string];
}

/// QQ号的匹配
/// @param string 需要判断的字符串
+ (BOOL)isQQ:(NSString *)string {
    return [self matchRegular:@"^[1-9]\\d{4,9}$" matchString:string];
}

/// 邮箱的匹配
/// @param string 需要判断的字符串
+ (BOOL)isEmail:(NSString *)string {
    return [self matchRegular:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" matchString:string];
}

/// 手机号的匹配
/// @param string 需要判断的字符串
+ (BOOL)isPhoneNumber:(NSString *)string {
    return [self matchRegular:@"^1[0-9]{10}$" matchString:string];
}

/// 中文的匹配
/// @param string 需要判断的字符串
+ (BOOL)isChinese:(NSString *)string {
    return [self matchRegular:@"[\u4E00-\u9FA5]*" matchString:string];
}

/// 邮箱或手机号或qq号的匹配
/// @param string 需要判断的字符串
+ (BOOL)isEmailOrPhoneNumberOrQQ:(NSString *)string {
    if ([self isEmail:string]) {
        return YES;
    } else if ([self isPhoneNumber:string]) {
        return YES;
    } else if ([self isQQ:string]) {
        return YES;
    }
    return NO;
}

/// 过滤字符串中的是否有emoji
/// @param string 需要判断的字符串
+ (BOOL)isEmoji:(NSString *)string {
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

/// 匹配自定义正则
/// @param regulars 正则
/// @param matchString 需要匹配的字符串
+ (BOOL)matchCustomRegulars:(NSArray<NSString *> *)regulars matchString:(NSString *)matchString {
    BOOL result = YES;
    if (regulars.count == 0) return result;
    NSString *realRegEx;
    NSMutableArray *realRegExs = [NSMutableArray array];
    for (NSString *regEx in regulars) {
        realRegEx = [regEx stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        if (realRegEx.length) {
            [realRegExs addObject:realRegEx];
        }
    }
    for (NSString *regular in realRegExs) {
        result = [self matchRegular:regular matchString:matchString];
    }
    return result;
}

/// 匹配正则的方法
/// @param regular 正则语句的字符串
/// @param matchString 需要匹配的字符串
+ (BOOL)matchRegular:(NSString *)regular matchString:(NSString *)matchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    return [predicate evaluateWithObject:matchString];
}

/// 匹配输入的字符串
+ (BOOL)matchInputValue:(NSString *)value
          matchRuleType:(XGMatchRuleType)matchRuleType
          integerDigits:(NSInteger)integerDigits
          decimalPlaces:(NSInteger)decimalPlaces
    matchCustomRegulars:(NSArray<NSString *> *)customRules {
    switch (matchRuleType) {
        case XGMatchRuleTypeOnlyNumbers:
            return [XGMatchManager isNumbers:value];
        case XGMatchRuleTypeIntegersAndDecimals:
            return [XGMatchManager matchIntegers:integerDigits decimals:decimalPlaces matchString:value];
        case XGMatchRuleTypeLettersOrNumbersOrChinese:
            return [XGMatchManager isLettersOrNumbersOrChinese:value];
        case XGMatchRuleTypeLettersAndNumbers:
            return [XGMatchManager isLettersOrNumbers:value];
        case XGMatchRuleTypeCustom:
            return [XGMatchManager matchCustomRegulars:customRules matchString:value];
        case XGMatchRuleTypeEmailOrPhoneNumberOrQQ:
            return [XGMatchManager isEmailOrPhoneNumberOrQQ:value];
        case XGMatchRuleTypeCannotInputChinese:
            return ![XGMatchManager isChinese:value] && ![XGMatchManager isEmoji:value];
        default:
            return ![XGMatchManager isEmoji:value];
    }
}

/// 拼接字符串
+ (NSString *)getMatchContentWithOriginalText:(NSString *)originalText
                                  replaceText:(NSString *)replaceText
                                        range:(NSRange)range {
    NSMutableString *matchContent = [NSMutableString string];
    // 原始内容判空
    if (originalText.length) {
        NSMutableString *tempStr = [NSMutableString stringWithString:originalText];
        matchContent = tempStr;
    }
    // 新增内容越界处理
    if (replaceText.length) {
        if (range.location < matchContent.length) {
            [matchContent insertString:replaceText atIndex:range.location];
        }else {
            [matchContent appendString:replaceText];
        }
    }
    return matchContent;
}

/// 配置tips
+ (void)configTips:(NSString *)tips {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"//忽略方法未声明警告
    if ([vc respondsToSelector:@selector(showToast:)]) {
        [vc performSelector:@selector(showToast:) withObject:tips];
    }
#pragma clang diagnostic pop
}

/// 配置输入超出最大输入限制时的tips
+ (void)configTipsWhenInputExceededMax:(XGMatchRuleType)matchRuleType maxCount:(NSInteger)macCount {
    switch (matchRuleType) {
        case XGMatchRuleTypeOnlyNumbers:
        case XGMatchRuleTypeIntegersAndDecimals:
            [self configTips:[NSString stringWithFormat:@"您最多只能输入%@个数字",@(macCount)]];
            break ;
        default:
            [self configTips:[NSString stringWithFormat:@"您最多只能输入%@个字符",@(macCount)]];
            break ;
    }
}

/// 配置输入异常数据时的tips
+ (void)configTipsWhenInputException:(XGMatchRuleType)matchRuleType {
    switch (matchRuleType) {
        case XGMatchRuleTypeOnlyNumbers:
        case XGMatchRuleTypeIntegersAndDecimals:
            [self configTips:@"请输入数字"];
            break ;
        case XGMatchRuleTypeLettersOrNumbersOrChinese:
            [self configTips:@"请输入字母或数字或中文"];
            break ;
        case XGMatchRuleTypeLettersAndNumbers:
            [self configTips:@"请输入字母或数字"];
            break ;
        case XGMatchRuleTypeCustom:
            [self configTips:@"请输入合法的字符"];
            break ;
        case XGMatchRuleTypeEmailOrPhoneNumberOrQQ:
            [self configTips:@"请输入合法的QQ或手机或邮箱"];
            break ;
        case XGMatchRuleTypeCannotInputChinese:
            [self configTips:@"请勿输入中文或emoji表情"];
            break ;
        default:
            [self configTips:@"请勿输入emoji表情"];
            break ;
    }
}

@end
