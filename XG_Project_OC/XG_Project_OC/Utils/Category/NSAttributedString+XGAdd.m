//
//  NSAttributedString+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "NSAttributedString+XGAdd.h"
#import "NSArray+XGAdd.h"

@implementation NSAttributedString (XGAdd)

+ (NSAttributedString *)setAttributedStringWithString:(NSString *)string configArray:(NSArray<XGAttributedConfig *> *)configArray {
    if (!configArray.xg_isArray) {
        return nil;
    }
    if (configArray.count == 0) {
        return nil;
    }
    if (!string.xg_isString) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    CGFloat nextTextLocation = 0;/** 下一段文字的起始位置下标 */
    CGFloat lastTextLenth = 0;/** 上一段文字的长度 */
    for (int i = 0; i < configArray.count; i++) {
        XGAttributedConfig *config = [configArray safeValue:i];
        /*xg< 处理每一段文字 */
        [attributedString addAttribute:NSFontAttributeName
                                 value:config.font
                                 range:NSMakeRange(nextTextLocation, config.text.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:config.textColor
                                 range:NSMakeRange(nextTextLocation, config.text.length)];
        
        /** 处理每一段文字的行间距 */
        if (config.lineSpace > 0) {
            NSRange lineRange = NSMakeRange(nextTextLocation - lastTextLenth ,lastTextLenth + config.text.length);
            NSMutableParagraphStyle *secondParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            [secondParagraphStyle setLineSpacing:config.lineSpace];
            [attributedString addAttribute:NSParagraphStyleAttributeName
                                     value:secondParagraphStyle
                                     range:lineRange];
        }
        
        nextTextLocation += config.text.length;
        lastTextLenth = config.text.length;
    }
    return attributedString;
}

/// 便捷构造方法
+ (NSAttributedString *)attributedTextWithString:(NSString *)string
                                            font:(UIFont *)font
                                           color:(UIColor *)color {
    return [[NSAttributedString alloc] initWithString:string
                                           attributes:@{NSFontAttributeName : font,
                                                        NSForegroundColorAttributeName: color}];
}

@end

@implementation XGAttributedConfig

@end
