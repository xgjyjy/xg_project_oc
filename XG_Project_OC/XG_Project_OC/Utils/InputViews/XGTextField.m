//
//  XGTextField.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGTextField.h"
#import "XGDynamicDelegate.h"

@interface XGTextField ()

@property (nonatomic, assign) NSRange selectionRange;

@property (nonatomic,   copy) NSString *historyText;

@end

@implementation XGTextField

/// 告诉编译器,属性的setter与getter方法自己实现，不自动生成
@dynamic delegate;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)load {
    @autoreleasepool {
        [self xg_registerDynamicDelegate];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _maxCount = 99999;
        _decimalPlaces = 2;
        _isDisplayInputExceptionTips = YES;
        _isDisplayInputExceededMaxTips = YES;
        self.backgroundColor = [UIColor xg_backgroundColor];
        self.placeholder = @"请输入";
        self.font = [UIFont xg_pingFangFontOfSize:15];
        self.textColor = [UIColor xg_blackColor];
        self.placeholderColor = [UIColor xg_lightGrayColor];
        [self addNotifications];
        [self addConfigs];
        if (!self.delegate) [self addDelegate];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addNotifications];
    [self addConfigs];
    if (!self.delegate) [self addDelegate];
}

#pragma mark - PublicMethods

- (void)clearCache {
    self.text = @"";
    _historyText = nil;
}

#pragma mark - PrivateMethods

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self];
}

- (void)addDelegate {
    self.delegate = nil;
}

- (void)addConfigs {
    self.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)configExceededMaximumInputWarning {
    if (self.isDisplayInputExceededMaxTips) {
        [XGMatchManager configTipsWhenInputExceededMax:self.matchRuleType maxCount:self.maxCount];
    }
    [self sendIllegalMsgToObject:@selector(xg_textFieldExceededMaximumInputWarning:)];
}

- (void)configInputExceptionWarning {
    if (self.isDisplayInputExceptionTips) {
        [XGMatchManager configTipsWhenInputException:self.matchRuleType];
    }
    [self sendIllegalMsgToObject:@selector(xg_textFieldInputExceptionWarning:)];
}

- (void)sendIllegalMsgToObject:(SEL)sel {
    if (self.delegate && [self.delegate.class isSubclassOfClass:[XGDynamicDelegate class]]) {
        XGDynamicDelegate *dynamicDelegate = (XGDynamicDelegate *)self.delegate;
        [dynamicDelegate sendMsgToObject:dynamicDelegate.realDelegate with:self SEL:sel];
    }
}

- (NSRange)rangeFromTextRange:(UITextRange *)textRange {
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:textRange.start];
    NSInteger length = [self offsetFromPosition:textRange.start toPosition:textRange.end];
    return NSMakeRange(location, length);
}

- (void)resetSelectionTextRange{
    _selectionRange = NSMakeRange(0, 0);
}

#pragma mark - Setter + Getter Methods

- (void)setCustomRules:(NSArray<NSString *> *)customRules {
    _customRules = customRules;
    [self clearCache];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    if (!placeholderColor || !self.placeholder) {
        return ;
    }
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor,NSFontAttributeName:self.font}];
}

#pragma mark - NSNotification

// 主要用于处理 高亮 文本
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification {
    if (self != notification.object) return;
    UITextField *textField = notification.object;
    NSString *currentText = textField.text;
    if (self.matchRuleType == XGMatchRuleTypeIntegersAndDecimals &&
        ([currentText isEqualToString:@"0"] || [currentText isEqualToString:@"."])) {
        textField.text = nil;
    }
    if (self.matchRuleType == XGMatchRuleTypeIntegersAndDecimals) {
        self.maxCount = self.integerDigits + self.decimalPlaces + 1;// 重新计算最大个数
    }
    NSInteger maxLength = self.maxCount;
    //获取高亮部分
    UITextRange *markedTextRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:markedTextRange.start offset:0];
    
    BOOL isMatch = [XGMatchManager matchInputValue:currentText
                                     matchRuleType:self.matchRuleType
                                     integerDigits:self.integerDigits
                                     decimalPlaces:self.decimalPlaces
                               matchCustomRegulars:self.customRules];
    if (isMatch) {
        self.historyText = textField.text;
    }
    // 没有高亮选择的字，则对已输入的字符进行数量统计和限制
    if (!position) {
        BOOL flag = NO;
        if (currentText.length > maxLength) {
            // Use the rangeOfComposedCharacterSequenceAtIndex: method
            // to make sure that Unicode characters, like emojis, don’t get torn apart.
            NSRange range = [currentText rangeOfComposedCharacterSequenceAtIndex:maxLength];
            textField.text = [currentText substringToIndex:range.location];
            flag = YES;
        }
        
        if (self.isTextSelecting && !isMatch) {
            flag = YES;
            NSString *historyText = self.historyText;
            if (!historyText.length) {
                textField.text = @"";
            }else {
                if (self.historyText.length <= textField.text.length) {
                    textField.text = self.historyText;
                }
            }
        }
        if (_selectionRange.length && !isMatch && (_selectionRange.length + _selectionRange.location <= currentText.length)) {
            NSString *limitedText = [currentText substringWithRange:_selectionRange];
            textField.text = [textField.text stringByReplacingOccurrencesOfString:limitedText withString:@""];
            _selectionRange = NSMakeRange(0, 0);
            if (limitedText.length) {
                flag = YES;
            }
        }
        if (flag) [self configExceededMaximumInputWarning];
    }else {
        _selectionRange = [self rangeFromTextRange:textField.markedTextRange];
    }
}

@end

#pragma mark - HBDynamicXGTextFieldDelegate

@interface HBDynamicXGTextFieldDelegate: XGDynamicDelegate

@end

@implementation HBDynamicXGTextFieldDelegate

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
        flag = [realDelegate textFieldShouldBeginEditing:textField];
    return flag;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [realDelegate textFieldDidBeginEditing:textField];
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
        flag = [realDelegate textFieldShouldEndEditing:textField];
    return flag;
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [realDelegate textFieldDidEndEditing:textField];
    
    // Coding...TODO
}

// if implemented, called in place of textFieldDidEndEditing:
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
        [realDelegate textFieldDidEndEditing:textField reason:reason];
    }else if ([self respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self textFieldDidEndEditing:textField];
    }
    
    // Coding...TODO
}

// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) return YES;// 允许输入删除键
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        flag = [realDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    BOOL matchResult = NO;
    if ([textField isKindOfClass:[XGTextField class]]) {
        XGTextField *limitedTextField = (XGTextField *)textField;
        [limitedTextField resetSelectionTextRange];// 重置 Mark Range. (即 候选文本)
        BOOL isExceedMaxLength = NO;
        if (textField.text.length < limitedTextField.maxCount) {
            NSString *matchString = string;
            if (limitedTextField.matchRuleType == XGMatchRuleTypeIntegersAndDecimals) {
                /** 先判断输入的字符串是不是合法的,合法之后再去匹配 */
                BOOL isNumbers = [XGMatchManager isNumbers:string];
                if (isNumbers || [string isEqualToString:@"."]) {
                    matchString = [XGMatchManager getMatchContentWithOriginalText:textField.text replaceText:string range:range];
                    matchResult = [XGMatchManager matchInputValue:matchString
                                                    matchRuleType:limitedTextField.matchRuleType
                                                    integerDigits:limitedTextField.integerDigits
                                                    decimalPlaces:limitedTextField.decimalPlaces
                                              matchCustomRegulars:limitedTextField.customRules];
                    /** 如果整数位已满时,还继续输入整数,就提示异常 */
                    if (limitedTextField.isDisplayInputExceptionTips && !matchResult && isNumbers) {
                        NSString *message = [NSString stringWithFormat:@"最多只能输入%@位整数",@(limitedTextField.integerDigits)];
                        [XGMatchManager configTips:message];
                        return NO;
                    }
                }
            } else {
                matchResult = [XGMatchManager matchInputValue:matchString
                                                matchRuleType:limitedTextField.matchRuleType
                                                integerDigits:limitedTextField.integerDigits
                                                decimalPlaces:limitedTextField.decimalPlaces
                                          matchCustomRegulars:limitedTextField.customRules];
            }
        } else {
            isExceedMaxLength = YES;
        }
        BOOL result = flag && matchResult;
        // Send limited msg.
        if (!result && isExceedMaxLength) {
            [limitedTextField configExceededMaximumInputWarning];
        } else if (!result && !isExceedMaxLength) {
            [limitedTextField configInputExceptionWarning];
        }
        return result;
    }
    return matchResult && flag;
}

// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldShouldClear:)])
        flag = [realDelegate textFieldShouldClear:textField];
    return flag;
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
        flag = [realDelegate textFieldShouldReturn:textField];
    
    // Coding
    // TODO: Strings format
    
    return flag;
}

#pragma mark - Custom Methods (Remains) Unused

static bool (*hb_trigger0)(id, SEL, UITextField *);
- (BOOL)isResponseToSEL:(SEL)sel obj:(UITextField *)obj {
    if ([self.realDelegate respondsToSelector:sel]) {
        hb_trigger0 = (bool (*)(id, SEL, UITextField *))[(NSObject *)self.realDelegate methodForSelector:sel];
        if (hb_trigger0) {
            return hb_trigger0(self, sel, obj);
        }
    }
    return YES;
}

static void (*hb_trigger1)(id, SEL, UITextField *);
- (void)isResponseToSELWithoutResult:(SEL)sel obj:(UITextField *)obj {
    if ([self.realDelegate respondsToSelector:sel]) {
        hb_trigger1 = (void (*)(id, SEL, UITextField *))[(NSObject *)self.realDelegate methodForSelector:sel];
        if (hb_trigger1) {
            hb_trigger1(self, sel, obj);
        }
    }
}

@end
