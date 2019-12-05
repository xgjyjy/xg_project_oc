//
//  UIColor+XGColor.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/4.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct XGColorRef {
    float r;
    float g;
    float b;
    float a;
};

/// RGBA -> RGB 转换时使用的背景色 值为FFFFFF(Sketch画板默认背景色)
extern struct XGColorRef RGBBackgoundColor;

@interface UIColor (XGAdd)

/// hexString 转 UIColor 不支持RGBA 和 RRGGBBAA
+ (UIColor *)colorWithHexString:(NSString *)hexStr;
- (NSString *)RGBHexString;

/// 主色A-1 #DD2534 用于整个APP内所有的红色, 如正文/标题等突出文字
+ (UIColor *)mainColor_A1_DD2534;
/// 主色A-2 #333333 用于一级文字信息
+ (UIColor *)mainColor_A2_333333;

/// 辅色B-1 #FF7C31 用于辅助性颜色
+ (UIColor *)minorColor_B1_FF7C31;
/// 辅色B-2 #FAFAFA 用于背景色以及搜索框背景色等
+ (UIColor *)minorColor_B2_FAFAFA;
/// 辅色B-3 #EFEFEF 用于列表类分割线
+ (UIColor *)minorColor_B3_EFEFEF;
/// 辅色B-4 #F1F1F1 用于背景色以及搜索框背景色等
+ (UIColor *)minorColor_B4_F1F1F1;

/// 文字颜色C-1 #666666 用于二级文字信息, 如绑定公司/绑定门店等
+ (UIColor *)textColor_C1_666666;
/// 文字颜色C-2 #999999 用于三级文字信息, 如时间/解释类信息等
+ (UIColor *)textColor_C2_999999;
/// 文字颜色C-3 #CCCCCC 用于文本编辑前和不可点击文字
+ (UIColor *)textColor_C3_CCCCCC;

@end

NS_ASSUME_NONNULL_END
