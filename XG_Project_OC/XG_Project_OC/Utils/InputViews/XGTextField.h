//
//  XGTextField.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGMatchManager.h"

NS_ASSUME_NONNULL_BEGIN

@class XGTextField;
@protocol XGTextFieldDelegate <NSObject,UITextFieldDelegate>

@optional

/// 超出最大输入限制警告
- (void)xg_textFieldExceededMaximumInputWarning:(XGTextField *)textField ;

/// 输入异常数据警告(默认有输入异常警告tips,外界可不用实现)
- (void)xg_textFieldInputExceptionWarning:(XGTextField *)textField ;

@end

@interface XGTextField : UITextField

/// 代理
@property (nonatomic,   weak) id<XGTextFieldDelegate> delegate;

/// 过滤规则类型
@property (nonatomic, assign) XGMatchRuleType matchRuleType;

/// 保留几位小数(matchRuleType == HBMatchRuleTypeIntegersAndDecimals 有效 默认保留2位小数)
@property (nonatomic, assign) NSInteger decimalPlaces;

/// 整数位数(matchRuleType == HBMatchRuleTypeIntegersAndDecimals 有效)
@property (nonatomic, assign) NSInteger integerDigits;

/// 自定义正则匹配规则(matchRuleType == HBMatchRuleTypeCustom 有效)
@property (nonatomic,   copy) NSArray <NSString *> *customRules;

/// 最大输入个数(matchRuleType != HBMatchRuleTypeIntegersAndDecimals 有效)
@property (nonatomic, assign) NSInteger maxCount;

/// 占位文字颜色(注意:必须先设占位文字和Font,才可以设置占位文字颜色,默认xg_lightGrayColor)
@property (nonatomic, strong) UIColor *placeholderColor;

/// 针对部分输入法含高亮选择文本，如：中文输入法 (默认NO)
@property (nonatomic, assign) BOOL isTextSelecting;

/// 输入异常数据时,是否提示tips (默认YES提示)
@property (nonatomic, assign) BOOL isDisplayInputExceptionTips;

/// 输入超出macCount时,是否自动提示tips (默认YES提示)
@property (nonatomic, assign) BOOL isDisplayInputExceededMaxTips;

/// 清除已输入的数据
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
