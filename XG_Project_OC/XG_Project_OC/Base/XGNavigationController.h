//
//  XGNavigationController.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/4.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGNavigationController : UINavigationController

/// 是否可右滑返回
/// @param isCanDragBack yes是 no不是
- (void)navigationCanDragBack:(BOOL)isCanDragBack;

/// push 到指定控制器的方法
/// @param viewController 指定的vc
/// @param animated 是否需要动画效果
/// @param hiddenTabbar 是否隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hiddenTabbar:(BOOL)hiddenTabbar;

@end

NS_ASSUME_NONNULL_END
