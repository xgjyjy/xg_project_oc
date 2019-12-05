//
//  NSAttributedString+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGAttributedConfig : NSObject

///每段文字的内容
@property (nonatomic,   copy) NSString *text;

///每段文字的颜色
@property (nonatomic, strong) UIColor *textColor;

///每段文字的字体
@property (nonatomic, strong) UIFont *font;

///每段文字的行间距(默认为0,使用系统自带的间距)
@property (nonatomic, assign) CGFloat lineSpace;

@end

@interface NSAttributedString (XGAdd)

/**
 将字符串显示成多种不同字体、大小和颜色的文字
 
 @param string 需要处理的完整字符串
 @param configArray 具体的配置
 @return 处理好的文字
 */
+ (NSAttributedString *)setAttributedStringWithString:(NSString *)string
                                          configArray:(NSArray<XGAttributedConfig *> *)configArray;

/// 便捷构造方法
+ (NSAttributedString *)attributedTextWithString:(NSString *)string
                                            font:(UIFont *)font
                                           color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
