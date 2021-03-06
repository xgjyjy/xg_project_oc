//
//  UIColor+XGColor.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/4.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "UIColor+XGAdd.h"

@implementation UIColor (XGAdd)

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    sscanf([str stringByTrimmingCharactersInSet:set].UTF8String, "%X", &result);
    return result;
}

static BOOL hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    str = [[str stringByTrimmingCharactersInSet:set] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

+ (UIColor *)xg_colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return [UIColor clearColor];
}

- (NSString *)xg_RGBHexString {
    CGColorRef CGColor = CGColorCreateCopy(self.CGColor);
    NSString *hexString = nil;
    
    /**
     假设背景颜色的值为(bg.r, bg.g, bg.b)，
     而需要设置的透明色（RGBA模式）为(color.r, color.g, color.b, a) a为小数
     目标值转换成模式为
     R = (1 - a) * bg.r + a * color.r
     G = (1 - a) * bg.g + a * color.g
     B = (1 - a) * bg.b + a * color.b
     */
    if (CGColorGetNumberOfComponents(CGColor) == 2) {
        const CGFloat *colorComponents = CGColorGetComponents(CGColor);
        CGFloat alpha = colorComponents[1];
        int rgb = floor(((1.0 - alpha) * colorComponents[0] + alpha * colorComponents[0]) * 255.0);
        hexString = [NSString stringWithFormat:@"%02X%02X%02X", rgb, rgb, rgb];
    }
    else if (CGColorGetNumberOfComponents(CGColor) == 4) {
        const CGFloat * colorComponents = CGColorGetComponents(CGColor);
        CGFloat alpha = colorComponents[3];
        int r = floor(((RGBBackgoundColor.r - alpha) * RGBBackgoundColor.r + alpha * colorComponents[0]) * 255.0);
        int g = floor(((RGBBackgoundColor.g - alpha) * RGBBackgoundColor.g + alpha * colorComponents[1]) * 255.0);
        int b = floor(((RGBBackgoundColor.b - alpha) * RGBBackgoundColor.b + alpha * colorComponents[2]) * 255.0);
        hexString = [NSString stringWithFormat:@"%02X%02X%02X", r, g, b];
    }
    
    CFRelease(CGColor);
    return hexString;
}

+ (UIColor *)xg_backgroundColor {
    return [self xg_colorWithHexString:@"EFEFEF"];
}

+ (UIColor *)xg_contentColor {
    return [self xg_colorWithHexString:@"FFFFFF"];
}

+ (UIColor *)xg_separatorLineColor {
    return [self xg_colorWithHexString:@"EAEAEA"];
}

+ (UIColor *)xg_redColor {
    return [self xg_colorWithHexString:@"DD2534"];
}

+ (UIColor *)xg_orangeColor {
    return [self xg_colorWithHexString:@"FF9D17"];
}

+ (UIColor *)xg_blueColor {
    return [self xg_colorWithHexString:@"2484FF"];
}

+ (UIColor *)xg_blackColor {
    return [self xg_colorWithHexString:@"333333"];
}

+ (UIColor *)xg_darkGrayColor {
    return [self xg_colorWithHexString:@"656565"];
}

+ (UIColor *)xg_grayColor {
    return [self xg_colorWithHexString:@"939393"];
}

+ (UIColor *)xg_lightGrayColor {
    return [self xg_colorWithHexString:@"CCCCCC"];
}

@end

struct XGColorRef RGBBackgoundColor = {1.0, 1.0, 1.0, 1.0};
