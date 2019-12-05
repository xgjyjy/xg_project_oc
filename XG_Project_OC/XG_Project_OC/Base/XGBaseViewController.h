//
//  XGBaseViewController.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/4.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGBaseViewController : UIViewController

/// 自定义的navigationBarView
@property (nonatomic, strong) UIView *navigationBarView;

/// 返回按钮
@property (nonatomic, strong) UIButton *navigationBarBackButton;

@property (nonatomic, strong, readonly) UILabel *titleLabel;

///左滑返回的开关
@property (nonatomic, assign) BOOL xzy_enableDragBack;

/**
 关闭scrollView自适应内边距
 
 */
- (void)scrollViewContentInsetAdjustmentNever:(UIScrollView *)scrollView;

/**
 设置当前控制器的title

 @param text 内容
 */
- (void)setTitleText:(NSString *)text;

/**
 设置当前控制器的title的字体颜色

 @param color 颜色
 */
- (void)setTitleColor:(UIColor *)color;

/**
 设置当前控制器的title的字体大小

 @param font 字体
 */
- (void)setTitleFont:(UIFont *)font;

/**
 设置当前控制器的title的富文本

 @param text 内容
 */
- (void)setTitleAttributedText:(NSAttributedString *)text;

/**
 返回按钮的事件

 @param sender 返回按钮
 */
- (void)navigationBarBackButtonClick:(UIButton *)sender;

/**
 显示返回按钮
 */
- (void)showNavigationBarBackButton;

/**
 显示分割线
 */
- (void)showNavigationBarLine;

/**
 显示NavigationBarView的阴影
 */
- (void)showNavigationBarViewShadow;

@end

NS_ASSUME_NONNULL_END
