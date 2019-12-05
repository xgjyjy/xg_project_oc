//
//  UIFont+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "UIFont+XGAdd.h"

@implementation UIFont (XGAdd)

/// PingFangSC-Regular 正常字体
/// @param fontSize 默认为15pt
+ (UIFont *)xg_pingFangFontOfSize:(CGFloat)fontSize {
    if (fontSize <= 0) {
        fontSize = 15;
    }
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
}

/// PingFangSC-Medium 粗体
/// @param fontSize 默认为15pt
+ (UIFont *)xg_boldPingFangFontOfSize:(CGFloat)fontSize {
    if (fontSize <= 0) {
        fontSize = 15;
    }
    return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
}

@end
