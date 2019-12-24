//
//  XGAboutUsViewController.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/21.
//  Copytrailing © 2019 XG_Project_OC. All trailings reserved.
//

#import "XGAboutUsViewController.h"
#import "NSAttributedString+XGAdd.h"
#import <YYText.h>

@interface XGAboutUsViewController ()

/// logo
@property (nonatomic, strong) UIImageView *logoImageView;

/// app姓名和版本号
@property (nonatomic, strong) UILabel *nameAndVersionLabel;

/// app介绍
@property (nonatomic, strong) YYLabel *appIntroductionLabel;

/// 联系view
@property (nonatomic, strong) UIView *contactInformationView;

/// 联系数据集合
@property (nonatomic, strong) NSMutableArray *contactInformationLabelArray;

@end

@implementation XGAboutUsViewController

#pragma mark - LifeCycle

- (void)dealloc{
    XLog(@"当前界面销毁了%@",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"关于我们"];
    [self showNavigationBarBackButton];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.nameAndVersionLabel];
    [self.view addSubview:self.appIntroductionLabel];
    [self.view addSubview:self.contactInformationView];
    [self layoutPageSubviews];
    [self addContactInformationLabel];
}

#pragma mark - PrivateMethods

- (void)addContactInformationLabel {
    NSArray *titleArray = @[@"电话:",@"深圳:",@"邮箱:",@"地址:"];
    NSArray *valueArray = @[@"4008-800-002",@"0755-86213811、86213813、86213823",@"Kefu@zhaoshang800.com",@"深圳市南山区沙河西路深圳湾科技生态园9栋B2座21楼"];
    CGFloat nextValueLabelY = 15;
    CGFloat titleW = 35;
    CGFloat titleH = [UIFont systemFontOfSize:15].lineHeight;
    CGFloat valueX = 55;
    CGFloat valueMaxW = kScreenWidth - valueX - 15;
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont xg_pingFangFontOfSize:15];
        titleLabel.textColor = [UIColor xg_darkGrayColor];
        [self.contactInformationView addSubview:titleLabel];
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.text = valueArray[i];
        valueLabel.font = [UIFont xg_pingFangFontOfSize:15];
        valueLabel.textColor = [UIColor xg_blackColor];
        valueLabel.numberOfLines = 0;
        [self.contactInformationView addSubview:valueLabel];
        valueLabel.preferredMaxLayoutWidth = valueMaxW;
        CGSize valueSize = [valueLabel sizeThatFits:CGSizeMake(valueMaxW, CGFLOAT_MAX)];
        valueLabel.frame = CGRectMake(valueX, nextValueLabelY, valueMaxW, valueSize.height);
        titleLabel.frame = CGRectMake(15, nextValueLabelY, titleW, titleH);
        nextValueLabelY = CGRectGetMaxY(valueLabel.frame) + 5;
    }
}

#pragma mark - LayoutPageSubviews

- (void)layoutPageSubviews {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kContentY + 30);
        make.centerX.equalTo(self.view);
    }];
    [self.nameAndVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    CGSize size = [self.appIntroductionLabel sizeThatFits:CGSizeMake(kScreenWidth, CGFLOAT_MAX)];
    [self.appIntroductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.nameAndVersionLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(size.height);
    }];
    [self.contactInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.appIntroductionLabel.mas_bottom).offset(10);
    }];
}

#pragma mark - Getter&Setter

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutpage_logo"]];
        _logoImageView.backgroundColor = self.view.backgroundColor;
    }
    return _logoImageView;
}

- (UILabel *)nameAndVersionLabel {
    if (!_nameAndVersionLabel) {
        _nameAndVersionLabel = [[UILabel alloc] init];
        _nameAndVersionLabel.backgroundColor = self.view.backgroundColor;
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *text = [NSString stringWithFormat:@"%@\nV%@",appName,appVersion];
        XGAttributedConfig *config1 = [[XGAttributedConfig alloc] init];
        config1.text = appName;
        config1.textColor = [UIColor xg_blackColor];
        config1.font = [UIFont xg_pingFangFontOfSize:15];
        config1.lineSpace = 5;
        XGAttributedConfig *config2 = [[XGAttributedConfig alloc] init];
        config2.text = [NSString stringWithFormat:@"\nV%@",appVersion];
        config2.textColor = [UIColor xg_blackColor];
        config2.font = [UIFont xg_pingFangFontOfSize:10];
        config2.lineSpace = 5;
        _nameAndVersionLabel.attributedText = [NSAttributedString setAttributedString:text configArray:@[config1,config2]];
        _nameAndVersionLabel.textAlignment = NSTextAlignmentCenter;
        _nameAndVersionLabel.numberOfLines = 0;
    }
    return _nameAndVersionLabel;
}

- (YYLabel *)appIntroductionLabel {
    if (!_appIntroductionLabel) {
        _appIntroductionLabel = [[YYLabel alloc] init];
        _appIntroductionLabel.backgroundColor = [UIColor whiteColor];
        _appIntroductionLabel.numberOfLines = 0;
        NSString *text = @"基于中工招商网数百万产业资源，伙伴集团打造一站式企业选址服务平台--选址易，提供海量优质厂房、土地、写字楼、产业园区租售服务，帮助用户省时、省心、快速选址。为中小微型企业提供全方位、多元化的企业增值服务，助力企业提升核心竞争力。";
        XGAttributedConfig *config = [[XGAttributedConfig alloc] init];
        config.text = text;
        config.textColor = [UIColor xg_blackColor];
        config.font = [UIFont xg_pingFangFontOfSize:15];
        config.lineSpace = 5;
        _appIntroductionLabel.attributedText = [NSAttributedString setAttributedString:text configArray:@[config]];
        _appIntroductionLabel.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _appIntroductionLabel;
}

- (UIView *)contactInformationView {
    if (!_contactInformationView) {
        _contactInformationView = [[UIView alloc] init];
        _contactInformationView.backgroundColor = [UIColor whiteColor];
    }
    return _contactInformationView;
}

- (NSMutableArray *)contactInformationLabelArray {
    if (!_contactInformationLabelArray) {
        _contactInformationLabelArray = [NSMutableArray array];
    }
    return _contactInformationLabelArray;
}

@end
