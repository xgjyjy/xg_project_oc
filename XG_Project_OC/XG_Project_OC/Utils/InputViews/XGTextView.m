//
//  XGTextView.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGTextView.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import <YYCategories/YYCategories.h>

@interface XGTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *inputTextView;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation XGTextView

@synthesize text = _text;
@synthesize editable = _editable;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _maxCount = 99999;
        _decimalPlaces = 2;
        _isDisplayInputExceptionTips = YES;
        _isDisplayInputExceededMaxTips = YES;
        self.backgroundColor = [UIColor xg_backgroundColor];
        [self addSubview:self.inputTextView];
        [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self);
        }];
        [self addSubview:self.countLabel];
        self.maxCount = 100;
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputTextView.mas_bottom);
            make.height.mas_equalTo(13);
            make.trailing.bottom.offset(-10);
        }];
    }
    return self;
}

#pragma mark - Override

- (BOOL)becomeFirstResponder {
    [self.inputTextView becomeFirstResponder];
    return [super becomeFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(xg_textViewShouldBeginEditing:)]) {
        return [self.delegate xg_textViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(xg_textViewShouldEndEditing:)]) {
        return [self.delegate xg_textViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(xg_textViewDidBeginEditing:)]) {
        [self.delegate xg_textViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(xg_textViewDidEndEditing:)]) {
        [self.delegate xg_textViewDidEndEditing:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(xg_textViewDidChangeSelection:)]) {
        [self.delegate xg_textViewDidChangeSelection:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(xg_textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate xg_textView:self shouldChangeTextInRange:range replacementText:text];
    }
    
    if ([text isEqualToString:@""]) return YES;// 允许输入删除键
    
    BOOL isCorrectValue = NO;
    BOOL isExceedMaxLength = NO;
    if (textView.text.length < self.maxCount) {
        NSString *matchString = text;
        if (self.matchRuleType == XGMatchRuleTypeIntegersAndDecimals) {
            /** 先判断输入的字符串是不是合法的,合法之后再去匹配 */
            BOOL isNumbers = [XGMatchManager isNumbers:text];
            if (isNumbers || [text isEqualToString:@"."]) {
                matchString = [XGMatchManager getMatchContentWithOriginalText:textView.text replaceText:text range:range];
                isCorrectValue = [XGMatchManager matchInputValue:matchString
                                                   matchRuleType:self.matchRuleType
                                                   integerDigits:self.integerDigits
                                                   decimalPlaces:self.decimalPlaces
                                             matchCustomRegulars:self.customRules];
                /** 如果整数位已满时,还继续输入整数,就提示异常 */
                if (self.isDisplayInputExceptionTips && !isCorrectValue && isNumbers) {
                    NSString *message = [NSString stringWithFormat:@"最多只能输入%@位整数",@(self.integerDigits)];
                    [XGMatchManager configTips:message];
                    return NO;
                }
            }
        } else {
            isCorrectValue = [XGMatchManager matchInputValue:matchString
                                               matchRuleType:self.matchRuleType
                                               integerDigits:self.integerDigits
                                               decimalPlaces:self.decimalPlaces
                                         matchCustomRegulars:self.customRules];
        }
        if (self.isDisplayInputExceptionTips && !isCorrectValue) [XGMatchManager configTipsWhenInputException:self.matchRuleType];
    } else {
        isExceedMaxLength = YES;
    }
    if (isExceedMaxLength && [self.delegate respondsToSelector:@selector(xg_textViewExceededMaximumInputWarning:)]) {
        [self.delegate xg_textViewExceededMaximumInputWarning:self];
    } else if (!isCorrectValue && [self.delegate respondsToSelector:@selector(xg_textViewInputExceptionWarning:)]) {
        [self.delegate xg_textViewInputExceptionWarning:self];
    }
    return isCorrectValue;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    BOOL isExceededInputLimit = NO;
    if (!position){
        if (text.length > self.maxCount) {
            isExceededInputLimit = YES;
            NSRange range = [text rangeOfComposedCharacterSequenceAtIndex:self.maxCount];
            textView.text = [text substringToIndex:range.location];
        }
    }
    if (self.matchRuleType == XGMatchRuleTypeIntegersAndDecimals &&
        ([textView.text isEqualToString:@"0"] || [textView.text isEqualToString:@"."])) {
        textView.text = nil;
    }
    if (self.isAdaptiveHeight) {
        CGFloat height = self.inputTextView.contentSize.height + self.countLabel.font.lineHeight + 10;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
    [self setCountLabelText];
    if (isExceededInputLimit) {
        [self configExceededMaximumInputWarning];
    }
    if ([self.delegate respondsToSelector:@selector(xg_textViewDidChange:)]) {
        [self.delegate xg_textViewDidChange:self];
    }
}

#pragma mark - PrivateMethods

- (void)configExceededMaximumInputWarning {
    if (self.isDisplayInputExceededMaxTips) {
        [XGMatchManager configTipsWhenInputExceededMax:self.matchRuleType maxCount:self.maxCount];
    }
    if ([self.delegate respondsToSelector:@selector(xg_textViewExceededMaximumInputWarning:)]) {
        [self.delegate xg_textViewExceededMaximumInputWarning:self];
    }
}

- (void)setCountLabelText {
    self.countLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.inputTextView.text.length), @(self.maxCount)];
}

#pragma mark - Set

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.inputTextView.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.inputTextView.font = font;
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    self.inputTextView.editable = editable;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.inputTextView.keyboardType = keyboardType;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.inputTextView.placeholder = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.inputTextView.placeholderColor = placeholderColor;
}

- (void)setMaxCount:(NSInteger)maxCount {
    if (self.matchRuleType == XGMatchRuleTypeIntegersAndDecimals) {// 重新计算最大个数
        maxCount = self.integerDigits + (self.decimalPlaces > 0 ? self.decimalPlaces + 1 : 3);
    }
    _maxCount = maxCount;
    [self setCountLabelText];
}

- (void)setIsHideMaxCount:(BOOL)isHideMaxCount {
    _isHideMaxCount = isHideMaxCount;
    self.countLabel.hidden = isHideMaxCount;
    if (isHideMaxCount) {
        [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            /** 移除约束  */
        }];
        [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self);
        }];
        [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputTextView.mas_bottom);
            make.height.mas_equalTo(13);
            make.trailing.bottom.offset(-10);
        }];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    if (text.length > self.maxCount) {
        text = [text substringToIndex:self.maxCount];
    }
    self.inputTextView.text = text;
    [self setCountLabelText];
}

- (void)setCountLabelFont:(UIFont *)countLabelFont {
    _countLabelFont = countLabelFont;
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(countLabelFont.lineHeight);
    }];
}

#pragma mark - Get

- (NSString *)text {
    return self.inputTextView.text.stringByTrim;
}

- (BOOL)editable {
    return self.inputTextView.isEditable;
}

#pragma mark - Getter&Setter

- (UITextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _inputTextView.delegate = self;
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.font = [UIFont xg_pingFangFontOfSize:15];
        _inputTextView.textColor = [UIColor xg_blackColor];
        _inputTextView.placeholderColor = [UIColor xg_lightGrayColor];
        _inputTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 10, 15);
        _inputTextView.textContainer.lineFragmentPadding = 0;
    }
    return _inputTextView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLabel.font = [UIFont xg_pingFangFontOfSize:12];
        _countLabel.textColor = [UIColor xg_grayColor];
    }
    return _countLabel;
}

@end
