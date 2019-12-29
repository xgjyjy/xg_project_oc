//
//  XGMatchManager.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 过滤规则类型
typedef NS_ENUM(NSUInteger, XGMatchRuleType) {
    /// 默认不做限制(只禁止emoji)
    XGMatchRuleTypeDefalut,
    
    /// 只能输入字母、数字和中文
    XGMatchRuleTypeLettersOrNumbersOrChinese,
    
    /// 只可以输入数字
    XGMatchRuleTypeOnlyNumbers,
    
    /// 只可以输入整数和小数(使用场景:价格等)
    XGMatchRuleTypeIntegersAndDecimals,
    
    /// 只能输入字母和数字(使用场景:验证码,身份证等)
    XGMatchRuleTypeLettersAndNumbers,
    
    /// 只能输入QQ号或邮箱或手机号(使用场景:联系方式等)
    XGMatchRuleTypeEmailOrPhoneNumberOrQQ,
    
    /// 不能输入中文
    XGMatchRuleTypeCannotInputChinese,
    
    /// 自定义过滤规则(正则)
    XGMatchRuleTypeCustom
};

@interface XGMatchManager : NSObject

/// 整数和小数的正则判断
/// @param integerDigits 整数位数
/// @param decimalPlaces 小数位数
/// @param matchString 需要判断的字符串
+ (BOOL)matchIntegers:(NSInteger)integerDigits
             decimals:(NSInteger)decimalPlaces
          matchString:(NSString *)matchString;

/// 字母、数字、中文正则判断（不包括空格）
/// 在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
/// @param string 需要判断的字符串
+ (BOOL)isLettersOrNumbersOrChinese:(NSString *)string;

/// 字母、数字、正则判断（不包括空格）
/// @param string 需要判断的字符串
+ (BOOL)isLettersOrNumbers:(NSString *)string;

/// 数字的正则判断（不包括空格）
/// @param string 需要判断的字符串
+ (BOOL)isNumbers:(NSString *)string;

/// 过滤字符串中的是否有emoji
/// @param string 需要判断的字符串
+ (BOOL)isEmoji:(NSString *)string;

/// QQ号的匹配
/// @param string 需要判断的字符串
+ (BOOL)isQQ:(NSString *)string;

/// 邮箱的匹配
/// @param string 需要判断的字符串
+ (BOOL)isEmail:(NSString *)string;

/// 手机号的匹配
/// @param string 需要判断的字符串
+ (BOOL)isPhoneNumber:(NSString *)string;

/// 邮箱或手机号或qq号的匹配
/// @param string 需要判断的字符串
+ (BOOL)isEmailOrPhoneNumberOrQQ:(NSString *)string;

/// 匹配自定义正则
/// @param regulars 正则
/// @param matchString 需要匹配的字符串
+ (BOOL)matchCustomRegulars:(NSArray <NSString *> *)regulars matchString:(NSString *)matchString;

/// 匹配输入的字符串
/// @param value 输入的字符串
/// @param matchRuleType 匹配规则内型
/// @param integerDigits 整数位数
/// @param decimalPlaces 小数位数
/// @param customRules 自定义规则集合
+ (BOOL)matchInputValue:(NSString *)value
          matchRuleType:(XGMatchRuleType)matchRuleType
          integerDigits:(NSInteger)integerDigits
          decimalPlaces:(NSInteger)decimalPlaces
    matchCustomRegulars:(NSArray<NSString *> *)customRules;

/// 拼接字符串
/// @param originalText 原始值
/// @param replaceText 新输入的值
/// @param range 范围
+ (NSString *)getMatchContentWithOriginalText:(NSString *)originalText
                                  replaceText:(NSString *)replaceText
                                        range:(NSRange)range;
/// 配置tips
+ (void)configTips:(NSString *)tips;

/// 配置输入超出最大输入限制时的tips
+ (void)configTipsWhenInputExceededMax:(XGMatchRuleType)matchRuleType maxCount:(NSInteger)macCount;

/// 配置输入异常数据时的tips
+ (void)configTipsWhenInputException:(XGMatchRuleType)matchRuleType;

@end

NS_ASSUME_NONNULL_END
