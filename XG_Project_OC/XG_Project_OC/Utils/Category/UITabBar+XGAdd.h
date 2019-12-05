//
//  UITabBar+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (XGAdd)

/**
 显示指定tabbar的小红点

 @param index tabbar的下标
 */
- (void)showBadgeOnItemIndex:(int)index;


/**
 隐藏指定tabbar的小红点

 @param index tabbar的下标
 */
- (void)hideBadgeOnItemIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
