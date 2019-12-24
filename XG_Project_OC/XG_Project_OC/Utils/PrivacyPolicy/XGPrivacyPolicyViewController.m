//
//  XGPrivacyPolicyViewController.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGPrivacyPolicyViewController.h"
//#import "XZYHTMLViewController.h"
#import "NSAttributedString+XGAdd.h"
#import <YYLabel.h>
#import <NSAttributedString+YYText.h>

@interface XGPrivacyPolicyViewController ()

@property (nonatomic, strong) UIView *privacyPolicyView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *headlineLabel;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *disagreeButton;

@end

@implementation XGPrivacyPolicyViewController

#pragma mark - LifeCycle

- (void)dealloc{
    XLog(@"当前界面销毁了%@",self);
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"XXX隐私政策"];
    self.navigationBarView.hidden = YES;
    self.xg_enableDragBack = NO;
    self.view.backgroundColor = [[UIColor xg_colorWithHexString:@"000000"] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.privacyPolicyView];
    [self.privacyPolicyView addSubview:self.contentView];
    [self.privacyPolicyView addSubview:self.logoImageView];
    [self.contentView addSubview:self.headlineLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.agreeButton];
    [self.contentView addSubview:self.disagreeButton];
    [self layoutPageSubviews];
}

#pragma mark - TargetAction
- (void)agreeButtonClick:(UIButton *)sender {
    if (self.agreeBackBlock) {
        self.agreeBackBlock();
    }
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)disagreeButtonClick:(UIButton *)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"不同意隐私政策将无法正常使用《XXX》的大部分服务，请返回同意隐私政策" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:alertAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - LayoutPageSubviews

- (void)layoutPageSubviews {
    [self.privacyPolicyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 390));
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.centerX.equalTo(self.privacyPolicyView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.right.bottom.equalTo(self.privacyPolicyView);
        make.height.mas_equalTo(345);
    }];
    [self.headlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.offset(74);
    }];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(300 - 2 * 24, CGFLOAT_MAX)
                                                            text:self.contentLabel.attributedText];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headlineLabel.mas_bottom).offset(20);
        make.leading.offset(24);
        make.trailing.offset(-24);
        make.height.mas_equalTo(layout.textBoundingSize.height);
    }];
    [self.disagreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(150, 45));
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(150, 45));
    }];
}

#pragma mark - Getter&Setter

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_privacy"]];
    }
    return _logoImageView;
}

- (UIView *)privacyPolicyView {
    if (!_privacyPolicyView) {
        _privacyPolicyView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _privacyPolicyView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor xg_colorWithHexString:@"FFFFFF"];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8;
    }
    return _contentView;
}

- (UILabel *)headlineLabel {
    if (!_headlineLabel) {
        _headlineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _headlineLabel.font = [UIFont systemFontOfSize:24];
        _headlineLabel.textColor = [UIColor xg_colorWithHexString:@"030303"];
        _headlineLabel.text = @"选址易隐私政策";
    }
    return _headlineLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"当您开始使用本软件时，我们可能会对您的部分个人信息进行收集、使用、共享和保护。请您在使用《XXX》前，花一些时间熟悉我们完整的《XXX隐私政策》，如有任何问题，请告诉我们。"];
        /** 设置字体大小和颜色 */
        [string addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14]
                       range:NSMakeRange(0, string.length)];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor xg_colorWithHexString:@"999999"]
                       range:NSMakeRange(0, string.length)];
        
        /** 添加行间距 */
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [string addAttribute:NSParagraphStyleAttributeName
                       value:paragraphStyle
                       range:NSMakeRange(0, string.length)];
        
        /** 添加点击事件 */
        [string yy_setTextHighlightRange:NSMakeRange(63, 9)
                                color:[UIColor redColor]
                      backgroundColor:[UIColor whiteColor]
                            tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                                XZYHTMLViewController *privacyPolicyVc = [[XZYHTMLViewController alloc] initWithVcTitle:@"XXX隐私政策" htmlName:@"privacyPolicy"];
//                                [self presentViewController:privacyPolicyVc animated:YES completion:nil];
                            }];
        
        _contentLabel.numberOfLines = 0;
        _contentLabel.attributedText = string;
    }
    return _contentLabel;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"icon_button_background"] forState:UIControlStateNormal];
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (UIButton *)disagreeButton {
    if (!_disagreeButton) {
        _disagreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _disagreeButton.backgroundColor = [UIColor xg_colorWithHexString:@"FAFAFA"];
        _disagreeButton.titleLabel.font =  [UIFont systemFontOfSize:15];
        [_disagreeButton setTitle:@"不同意" forState:UIControlStateNormal];
        [_disagreeButton setTitleColor:[UIColor xg_colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [_disagreeButton addTarget:self action:@selector(disagreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disagreeButton;
}

@end
