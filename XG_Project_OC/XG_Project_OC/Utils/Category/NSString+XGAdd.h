//
//  NSString+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XGAdd)

/**
 获得设备版本号

 @return 设备版本号
 */
+ (NSString *)getDeviceVersion;

/**
 获得当前设备型号

 @return 设备型号
 */
+ (NSString *)getDeviceType;

/**
 获得当前时间戳

 @return 时间戳
 */
+ (NSTimeInterval)getLocolTimeinterval;

/**
 时间显示规则: 当天:(HH:mm) 昨天:(昨天 HH:mm) 隔天:(月[月] 日[日] HH:mm) 跨年:(年[年] 月[月] 日[日] HH:mm)

 @param timeStamp 时间戳
 @return 时间字符串
 */
+ (NSString *)getTimeDisplay:(NSInteger)timeStamp;

/**
 精细时间显示规则:
 (1）小于一分钟：一分钟前；
 (2）大于等于一分钟、小于一小时：X分钟前；
 (3）大于一小时、小于24小时：X小时前
 (4）大于24小时，小于48小时：昨天；
 (5）大于等于48小时：年-月-日（xxxx-xx-xx）

 @param timeStamp 需要比较的时间戳
 @return 时间字符串
 */
+ (NSString *)getFineTimeDisplay:(NSInteger)timeStamp;

/// 判断当前时间是否在目标时间范围内
/// @param startTimeStamp 开始时间
/// @param expireTimeStamp 结束时间
+ (BOOL)judgeTimeByStartAndEnd:(long long)startTimeStamp withExpireTime:(long long)expireTimeStamp;

/**
 字母、数字、中文正则判断（不包括空格）
 
 @param str 需要判断的字符串
 @return yes(是字母、数字、中文) no(不是字母、不是数字、不是中文)
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)str;

/**
 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 
 @param str 需要判断的字符串
 @return yes(是字母、数字、中文) no(不是字母、不是数字、不是中文)
 */
+ (BOOL)isInputRuleAndBlank:(NSString *)str;

/**
 判断是否有emoji

 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 *  过滤字符串中的emoji
 */
+ (NSString *)disable_emoji:(NSString *)text;

/**
 * 将汉字转换为拼音
 */
+ (NSString *)transform:(NSString *)chinese;

/**
 将汉字转成拼音字符串或者首字母(搜索用)
 
 @param chinese 需要转换的汉字
 @return 拼音或者首字母
 */
+ (NSString *)transformToPinyin:(NSString *)chinese;

/**
 提取汉字拼音的首字母(大写)
 
 @param chinese 需要提取的汉字
 @return 拼音的首字母
 */
+ (NSString *)transformToInitial:(NSString *)chinese;

/**
 字母、数字、正则判断（不包括空格）
 
 @param str 需要判断的字符串
 @return yes(是字母、数字) no(不是字母、不是数字)
 */
+ (BOOL)isInputRuleNotBlankAndChinese:(NSString *)str;

/**
 中文、字母的正则判断

 @param string 需要判断的字符串
 @return yes(是字母、中文) no(不是)
 */
+ (BOOL)isInputChineseAndLetter:(NSString *)string;

/**
 中文的正则判断

 @param string 需要判断的字符串
 @return yes(是字母、中文) no(不是)
 */
+ (BOOL)isInputChinese:(NSString *)string;

/**
 数字的正则判断

 @param string 需要判断的字符串
 @return yes是数字 no不是数字
 */
+ (BOOL)isInputNumber:(NSString *)string;

/**
 身份证验证
 
 @param IDCardNumber 需要被判断的字符串
 @return yes(合法) no(不合法)
 */
+ (BOOL)isIdentityCard:(NSString *)IDCardNumber;

/**
 过滤字符串中的HTML标签
 
 @param html 需要过滤的字符串
 @return 过滤后的字符串
 */
+ (NSString *)flattenHTML:(NSString *)html ;

/**
 去掉小数位后面的0
 
 @param number 需要处理的小数字符串
 @return 处理好的小数字符串
 */
+ (NSString *)removeZerosAfterTheDecimalPoint:(NSString *)number;

/**
 判断url是否合法,如果不包含http,就自动添加上

 @param urlStr url
 @return 正确的url
 */
+ (NSString *)getCompleteWebsite:(NSString *)urlStr;

/**
 验证手机号的合法性

 @param mobileNum 手机号
 @return yes合法 no不合法
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 判断是否全是空格

 @param string 需要判断的字符串
 @return yes是 no不是
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 JSON字符串转化为字典

 @param jsonString json字符串
 @return 转换好的字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/// 将操过10000的数字类型转成中文万
+ (NSString *)convertTheNumberWanToChineseWan:(NSString *)numberWan;

@end

NS_ASSUME_NONNULL_END
