//
//  UIViewController+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/19.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XGAdd)

/// 显示吐司
/// @param text 需要显示的文本
- (void)showToast:(NSString *)text;

/// 隐藏吐司(一般情况下,不需要调用)
- (void)hideToast;

/// 显示loading
- (void)showLoading;

/// 显示loading
/// @param text loading的文本
- (void)showLoading:(NSString *)text;

/// 隐藏loading
- (void)hideLoading;

@end

NS_ASSUME_NONNULL_END
