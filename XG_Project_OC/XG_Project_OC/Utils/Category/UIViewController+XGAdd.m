//
//  UIViewController+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/19.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "UIViewController+XGAdd.h"
#import <MBProgressHUD.h>
#import "UIResponder+XGAdd.h"
#import "UIView+XGAdd.h"
#import <YYImage.h>

#if __has_include("XGBaseViewController.h")
#import "XGBaseViewController.h"
#define HasBaseViewContrller 1
#else
#define HasBaseViewContrller 0
#endif

@implementation UIViewController (XGAdd)

#pragma mark - Toast

- (void)showToast:(NSString *)text {
    [self showToastWithText:text margin:15 font:15 centerOffsetY:[self getContentY:YES]];
}

- (void)hideToast {
    [self disMissHud:1028];
}

- (void)showToastWithText:(NSString *)text
                   margin:(CGFloat)margin
                     font:(CGFloat)font
            centerOffsetY:(CGFloat)y {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        /** 添加阴影 */
        hud.bezelView.layer.cornerRadius = 5;
        hud.bezelView.layer.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.6].CGColor;
        hud.bezelView.layer.shadowOffset = CGSizeMake(0, 2);
        hud.bezelView.layer.shadowOpacity = 1;
        hud.bezelView.layer.shadowRadius = 5;
        hud.bezelView.layer.masksToBounds = NO;
        
        hud.margin = margin;
        hud.label.textColor = [UIColor whiteColor];
        hud.label.text = text;
        hud.label.font = [UIFont systemFontOfSize:font];
        hud.label.numberOfLines = 0;
        hud.tag = 1028;
        hud.Y = y;
        hud.height = [UIFont systemFontOfSize:font].lineHeight + 4 * margin;
        
        [hud showAnimated:YES];
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

#pragma mark - Loading

- (void)showLoading {
    CGFloat y = [self getContentY:NO];
    CGFloat h = kScreenHeight - y;
    [self showLoadingWithText:@"加载中..." frame:CGRectMake(0, y, kScreenWidth, h)];
}

- (void)showLoading:(NSString *)text {
    CGFloat y = [self getContentY:NO];
    CGFloat h = kScreenHeight - y;
    [self showLoadingWithText:text frame:CGRectMake(0, y, kScreenWidth, h)];
}

- (void)hideLoading {
    [self disMissHud:1024];
}

- (void)showLoadingWithText:(NSString *)text frame:(CGRect)frame {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.contentColor = [UIColor whiteColor];/** 菊花的颜色 */
        //        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        //        hud.bezelView.backgroundColor = [UIColor blackColor];/** 菊花所在方框的背景色 */
        
        /** 添加自定义loading */
        UIView *loadingView = [[UIView alloc] initWithFrame:CGRectZero];
        loadingView.layer.cornerRadius = 5;
        loadingView.backgroundColor = [UIColor blackColor];
        [hud addSubview:loadingView];
        
        /** 添加阴影 */
        loadingView.layer.cornerRadius = 5;
        loadingView.layer.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        loadingView.layer.shadowOffset = CGSizeMake(0, 2);
        loadingView.layer.shadowOpacity = 1;
        loadingView.layer.shadowRadius = 5;
        
        
        /** loading图片和动画 */
        YYImage *image = [YYImage imageNamed:@"loading.gif"];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [loadingView addSubview:imageView];
        [imageView startAnimating];
        
        /** 添加文字 */
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.text = text;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleLabel sizeToFit];
        [loadingView addSubview:titleLabel];
        
        /** 布局控件 */
        CGFloat margin = 15;
        CGFloat imageW = 30;
        CGFloat imageH = 30;
        CGFloat loadingViewW = imageW + 3 * margin + titleLabel.bounds.size.width;
        CGFloat loadingViewH = imageH + 2 * margin;
        CGFloat loadingViewX = (frame.size.width - loadingViewW) * 0.5;
        CGFloat loadingViewY = (frame.size.height - loadingViewH) * 0.5;
        loadingView.frame = CGRectMake(loadingViewX, loadingViewY, loadingViewW, loadingViewH);
        
        CGFloat imageX = margin;
        CGFloat imageY = (loadingViewH - imageH) * 0.5;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        CGFloat titleX = CGRectGetMaxX(imageView.frame) + margin;
        CGFloat titleY = (loadingViewH - titleLabel.bounds.size.height) * 0.5;
        titleLabel.origin = CGPointMake(titleX, titleY);
        
        hud.bezelView.hidden = YES;
        hud.mode = MBProgressHUDModeCustomView;
        hud.square = NO;
        hud.minSize = loadingView.size;
        hud.tag = 1024;
        hud.frame = frame;
        [hud showAnimated:YES];
    });
}

#pragma mark - PrivateMethods

- (void)disMissHud:(NSInteger)tag {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSEnumerator *subviewsEnum = [self.view.subviews reverseObjectEnumerator];
        for (UIView *subview in subviewsEnum) {
            if ([subview isKindOfClass:[MBProgressHUD class]]) {
                MBProgressHUD *hud = (MBProgressHUD *)subview;
                if (hud.tag == tag) {
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hideAnimated:YES];
                }
            }
        }
    });
}

- (CGFloat)getContentY:(BOOL)isToast {
    CGFloat y = 0;
#if HasBaseViewContrller
    if ([self isKindOfClass:[XGBaseViewController class]] && !((XGBaseViewController *)self).navigationBarView.hidden) {
        y = isToast ? (kScreenHeight - kContentY) * 0.5 : kContentY;
    }
#endif
    if ([self isDisplayKeyboard]) {
        CGFloat keyboardHeight = 0;
        if (@available(iOS 11.0, *)) {
            CGFloat safeBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
            keyboardHeight = (safeBottom > 0 ? safeBottom + 243 : 282) + 44;
        } else {
            keyboardHeight = 282 + 44;
        }
        y = (kScreenHeight - keyboardHeight) * 0.5;
    }
    return y;
}

- (BOOL)isDisplayKeyboard {
    id obj = [UIResponder currentFirstResponder];
    return [obj isKindOfClass:[UITextField class]] || [obj isKindOfClass:[UITextView class]];
}

@end
