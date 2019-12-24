//
//  XGTextView.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGMatchManager.h"

NS_ASSUME_NONNULL_BEGIN

@class XGTextView;
@protocol XGTextViewDelegate <NSObject>

@optional

- (BOOL)xg_textViewShouldBeginEditing:(XGTextView *)textView;
- (BOOL)xg_textViewShouldEndEditing:(XGTextView *)textView;

- (void)xg_textViewDidBeginEditing:(XGTextView *)textView;
- (void)xg_textViewDidEndEditing:(XGTextView *)textView;

- (BOOL)xg_textView:(XGTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)xg_textViewDidChange:(XGTextView *)textView;

- (void)xg_textViewDidChangeSelection:(XGTextView *)textView;

/// 超出最大输入限制警告
- (void)xg_textViewExceededMaximumInputWarning:(XGTextView *)textView ;

/// 输入异常数据警告(默认有输入异常警告tips,外界可不用实现)
- (void)xg_textViewInputExceptionWarning:(XGTextView *)textView ;

@end

@interface XGTextView : UIView

/// 是否自适应高度(默认NO)
@property (nonatomic, assign) BOOL isAdaptiveHeight;

/// 过滤规则类型
@property (nonatomic, assign) XGMatchRuleType matchRuleType;

/// 保留几位小数(matchRuleType == HBMatchRuleTypeIntegersAndDecimals 有效 默认保留2位小数)
@property (nonatomic, assign) NSInteger decimalPlaces;

/// 整数位数(matchRuleType == HBMatchRuleTypeIntegersAndDecimals 有效)
@property (nonatomic, assign) NSInteger integerDigits;

/// 自定义正则匹配规则(matchRuleType == HBMatchRuleTypeCustom 有效)
@property (nonatomic,   copy) NSArray <NSString *> *customRules;

/// 最大输入长度
@property (nonatomic, assign) NSInteger maxCount;

/// TextView值改变的代理
@property (nonatomic,   weak) id<XGTextViewDelegate> delegate;

/// TextView的占位文字
@property (nonatomic,   copy) NSString * _Nullable placeholder;

/// TextView的占位文字颜色
@property (nonatomic, strong) UIColor *placeholderColor;

/// TextView的文本
@property (nonatomic,   copy) NSString * _Nullable text;

/// TextView的文本颜色
@property (nonatomic, strong) UIColor *textColor;

/// TextView的字体
@property (nonatomic, strong) UIFont *font;

/// TextView的键盘类型
@property (nonatomic, assign) UIKeyboardType keyboardType;

/// TextView的编辑开关
@property (nonatomic, assign) BOOL editable;

/// 是否隐藏最大个数统计label(默认NO显示)
@property (nonatomic, assign) BOOL isHideMaxCount;

/// 输入异常数据时,是否自动提示tips (默认YES提示)
@property (nonatomic, assign) BOOL isDisplayInputExceptionTips;

/// 输入超出macCount时,是否自动提示tips (默认YES提示)
@property (nonatomic, assign) BOOL isDisplayInputExceededMaxTips;

/// countLabel的字体(默认 [UIFont hb_fontOfSize:15])
@property (nonatomic, strong) UIFont *countLabelFont;

/// countLabel的字体颜色(默认[UIColor hb_blackColor])
@property (nonatomic, strong) UIColor *countLabelColor;

@property (nonatomic, strong, readonly) UILabel *countLabel;
@property (nonatomic, strong, readonly) UITextView *inputTextView;

@end

NS_ASSUME_NONNULL_END
