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

@interface XGBaseViewControllerContainerView : UIView

@property (nonatomic, weak) UIView *navbar;

@end

@implementation XGBaseViewControllerContainerView

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
    self.view = [[XGBaseViewControllerContainerView alloc] initWithFrame:frame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor xg_backgroundColor];
    [self.view addSubview:self.navigationBarView];
    if ([self.view isKindOfClass:[XGBaseViewControllerContainerView class]]) {
        XGBaseViewControllerContainerView *view = (XGBaseViewControllerContainerView *)self.view;
        view.navbar = self.navigationBarView;
    }
    _xg_enableDragBack = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self navigationControllerCanDragBack:_xg_enableDragBack];
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
    self.navigationBarView.layer.shadowColor = [[UIColor xg_colorWithHexString:@"000000"] colorWithAlphaComponent:0.1].CGColor;
    self.navigationBarView.layer.shadowOffset = CGSizeMake(0, 2);
    self.navigationBarView.layer.shadowOpacity = 1;
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

- (void)setXg_enableDragBack:(BOOL)xg_enableDragBack {
    _xg_enableDragBack = xg_enableDragBack;
    [self navigationControllerCanDragBack:xg_enableDragBack];
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
        _navigationBarView.backgroundColor = [UIColor xg_backgroundColor];
    }
    return _navigationBarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor xg_blackColor];
        _titleLabel.font = [UIFont xg_pingFangFontOfSize:18];
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
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kContentY - 1, kScreenWidth, 1)];
        _lineView.backgroundColor = [UIColor xg_separatorLineColor];
    }
    return _lineView;
}

@end
