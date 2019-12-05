//
//  UIFont+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (XGAdd)

/// PingFangSC-Regular 正常字体
/// @param fontSize 默认为15pt
+ (UIFont *)xg_pingFangFontOfSize:(CGFloat)fontSize;

/// PingFangSC-Medium 粗体
/// @param fontSize 默认为15pt
+ (UIFont *)xg_boldPingFangFontOfSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
