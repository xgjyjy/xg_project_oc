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
+ (UIColor *)xg_colorWithHexString:(NSString *)hexStr;

- (NSString *)xg_RGBHexString;

+ (UIColor *)xg_backgroundColor;

+ (UIColor *)xg_contentColor;

+ (UIColor *)xg_separatorLineColor;

+ (UIColor *)xg_redColor;

+ (UIColor *)xg_orangeColor;

+ (UIColor *)xg_blueColor;

+ (UIColor *)xg_blackColor;

+ (UIColor *)xg_darkGrayColor;

+ (UIColor *)xg_grayColor;

+ (UIColor *)xg_lightGrayColor;

@end

NS_ASSUME_NONNULL_END
