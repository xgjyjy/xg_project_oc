//
//  XGBaseViewController.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/4.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGBaseViewController.h"
#import "XGNavigationController.h"
#import "UIColor+XGAdd.h"

@interface XZYBaseViewControllerContainerView : UIView

@property (nonatomic, weak) UIView *navbar;

@end

@implementation XZYBaseViewControllerContainerView

- (void)addSubview:(UIView *)view {
    if (_navbar) {
        [super insertSubview:view belowSubview:_navbar];
    } else {
        [super addSubview:view];
    }
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    if ([siblingSubview isEqual:_navbar]) {
        [super insertSubview:view belowSubview:_navbar];
    } else {
        [super insertSubview:view aboveSubview:siblingSubview];
    }
}

//- (void)bringSubviewToFront:(UIView *)view {
//    if (_navbar) {
//        if ([view.superview isEqual:self]) {
//            [super insertSubview:view belowSubview:_navbar];
//        }
//    } else {
//        [super bringSubviewToFront:view];
//    }
//}

- (void)sendSubviewToBack:(UIView *)view {
    if (![view isEqual:_navbar]) {
        [super sendSubviewToBack:view];
    }
}

- (void)setNavbar:(UIView *)navbar {
    _navbar = navbar;
    if (_navbar) {
        [super bringSubviewToFront:_navbar];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

@end

@interface XGBaseViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XGBaseViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;/** 去掉iOS13的模态效果 */
    }
    return self;
}

- (void)loadView {
    
    CGRect frame;
    if (CGSizeEqualToSize(self.preferredContentSize, CGSizeZero)) {
        if (self.navigationController) {
            frame = self.navigationController.view.bounds;
        } else {
            frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    } else {
        frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
    }
    self.view = [[XZYBaseViewControllerContainerView alloc] initWithFrame:frame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBarView];
    if ([self.view isKindOfClass:[XZYBaseViewControllerContainerView class]]) {
        XZYBaseViewControllerContainerView *view = (XZYBaseViewControllerContainerView *)self.view;
        view.navbar = self.navigationBarView;
    }
    _xzy_enableDragBack = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self navigationControllerCanDragBack:_xzy_enableDragBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    if (parent == nil) {
        return;
    }
    
    if (![parent isKindOfClass:[UINavigationController class]] && ![parent isKindOfClass:[UITabBarController class]]) {
        _navigationBarView.hidden = YES;
    }
}

- (void)navigationBarBackButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showNavigationBarBackButton {
    [self.navigationBarView addSubview:self.navigationBarBackButton];
}

- (void)showNavigationBarViewShadow {
    self.navigationBarView.layer.shadowColor = [[UIColor colorWithHexString:@"000000"] colorWithAlphaComponent:0.1].CGColor;
    self.navigationBarView.layer.shadowOffset = CGSizeMake(0, 2);
    self.navigationBarView.layer.shadowOpacity = 1;/**< 设置阴影的透明度 */
}

- (void)showNavigationBarLine {
    [self.navigationBarView addSubview:self.lineView];
}

- (void)navigationControllerCanDragBack:(BOOL)isCanDragBack {
    if (self.navigationController && [self.navigationController isKindOfClass:[XGNavigationController class]]) {
        [(XGNavigationController *)self.navigationController navigationCanDragBack:isCanDragBack];
    }
}

- (void)scrollViewContentInsetAdjustmentNever:(UIScrollView *)scrollView {
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setXzy_enableDragBack:(BOOL)xzy_enableDragBack {
    _xzy_enableDragBack = xzy_enableDragBack;
    [self navigationControllerCanDragBack:xzy_enableDragBack];
}

- (void)setTitleText:(NSString *)text {
    [self.navigationBarView addSubview:self.titleLabel];
    self.titleLabel.text = text;
    CGFloat maxW = kScreenWidth - (44 + 15) * 2;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(kScreenWidth, CGFLOAT_MAX)];
    CGFloat titleW = maxW > titleSize.width ? titleSize.width : maxW;
    CGFloat titleX = (kScreenWidth - titleW) * 0.5;
    CGFloat titleY = (kContentY - kStatusBarHeight - titleSize.height) * 0.5 + kStatusBarHeight;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleSize.height);
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}

- (void)setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}

- (void)setTitleAttributedText:(NSAttributedString *)text {
    [self.navigationBarView addSubview:self.titleLabel];
    self.titleLabel.attributedText = text;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat titleX = (kScreenWidth - titleSize.width) * 0.5 + kStatusBarHeight;
    CGFloat titleY = (kContentY - kStatusBarHeight - titleSize.height) * 0.5;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
}

- (UIView *)navigationBarView {
    if(!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentY)];
        _navigationBarView.backgroundColor = [UIColor whiteColor];
        //        _navigationBarView.layer.zPosition = 1000;
    }
    return _navigationBarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (UIButton *)navigationBarBackButton {
    if (!_navigationBarBackButton) {
        _navigationBarBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 44, 44)];
        [_navigationBarBackButton setImage:[UIImage imageNamed:@"nav_button_return_normal_black"] forState:UIControlStateNormal];
        [_navigationBarBackButton addTarget:self action:@selector(navigationBarBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationBarBackButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kContentY - 0.5, kScreenWidth, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    }
    return _lineView;
}

#pragma mark - ErrorTipView

//- (XZYErrorTipView *)errorTipView {
//    if (!_errorTipView) {
//        _errorTipView = [XZYErrorTipView new];
//        _errorTipView.backgroundColor = [UIColor whiteColor];
//        _errorTipView.delegate = self;
//        _errorTipView.hidden = YES;
//    }
//    return _errorTipView;
//}

//- (void)showErrorTipViewWithType:(ErrorType)errorType {
//    if (!self.errorTipView.superview) {
//        [self.view insertSubview:self.errorTipView belowSubview:self.navigationBarView];
//    } else {
//        [self.view bringSubviewToFront:self.navigationBarView];
//    }
//
//    if (CGRectEqualToRect(self.errorTipView.frame, CGRectZero)) {
//        UIView *baba = self.errorTipView.superview;
//        [self.errorTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.equalTo(baba);
//            make.width.equalTo(baba);
//            make.height.equalTo(baba);
//        }];
//    }
//
//    self.errorTipView.hidden = NO;
//    self.errorTipView.errorType = errorType;
//}
//
//- (void)hideErrorTipView {
//    self.errorTipView.hidden = YES;
//}
//
//- (void)errorTipViewDidTappedRefreshButton {}

#pragma mark - 自定义转场动画相关

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    UIPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    
    /// 如果是二楼下拉动画, 会强制覆盖transitioningDelegate
//    if ([viewControllerToPresent isKindOfClass:[XZYSecondFloorContainerController class]]) {
//        presentationController = [[XZYSecondFloorPresentationController alloc] initWithPresentedViewController:viewControllerToPresent presentingViewController:self];
//        viewControllerToPresent.transitioningDelegate = (XZYSecondFloorPresentationController *)presentationController;
//    }
//    else if ([viewControllerToPresent isKindOfClass:[XZYDialogController class]]) {
//        presentationController = [[XZYDialogPresentationController alloc] initWithPresentedViewController:viewControllerToPresent presentingViewController:self];
//        viewControllerToPresent.transitioningDelegate = (XZYDialogPresentationController *)presentationController;
//    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
