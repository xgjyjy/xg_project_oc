//
//  XGMineViewController.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGMineViewController.h"
#import "XGSettingViewController.h"
#import "XGMineListCell.h"
#import "UIView+XGAdd.h"
#import "NSObject+XGAdd.h"
#import "UIButton+XGAdd.h"
#import "NSDictionary+XGAdd.h"
#import "NSArray+XGAdd.h"
#import "UIFont+XGAdd.h"

static NSString * const identifer = @"XGMineListCell";

@interface XGMineViewController () <UITableViewDelegate,UITableViewDataSource>

/// 用户信息View
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIImageView *avatarShadow;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *editInfoButton;

/// 主要功能View
@property (nonatomic, strong) UIView *importantFeaturesView;
@property (nonatomic, strong) UIButton *findHouseButton;
@property (nonatomic, strong) UIButton *HelpMeRentOrSellButton;
@property (nonatomic, strong) UIButton *myFollowButton;

@property (nonatomic, assign) BOOL isHaveLogin;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation XGMineViewController

#pragma mark - LifeCycle

- (void)dealloc {
    XLog(@"%@ %s", self, __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshUI];
}

#pragma mark - PrivateMethods

- (void)refreshUI {
    //    NSString *token = [XZYUserDefaultManager getToken];
    //
    //    BOOL hadLogin = [token haveValueString];
    //    _isHaveLogin = hadLogin;
    //    self.loginButton.hidden = hadLogin;
    //    self.nicknameLabel.hidden = !hadLogin;
    //    self.editInfoButton.hidden = !hadLogin;
    
    //    NSDictionary *dataDict = [XZYUserDefaultManager getUserDataAfterLogin];
    //    NSString *nickname = [dataDict valueForKey:@"netName"];
    //    if (!nickname.xg_isString) {
    //        nickname = [dataDict valueForCheckKey:@"phone"];
    //    }
    //    if (!nickname.xg_isString) {
    //        nickname = @"****";
    //    }
    //    self.nicknameLabel.text = nickname;
    //    [self.avatarImageView xg_setImageWithURL:[dataDict valueForCheckKey:@"icon"]
    //                        placeholderImageName:@"mine_avatar_placeholder"];
    
    
    
}

- (void)pushToEditInfoViewController {
}

- (void)pushToLoginViewControllerWithCallback:(void (^)(void))callback {
    //    [[XZYLoginManager sharedManager] loginAccountWithCurrentVc:self];
    //    [XZYLoginManager sharedManager].loginSuccess = callback;
}

#pragma mark - TargetAction
- (void)settingButtonClick:(UIButton *)sender {
    XGSettingViewController *settingVc = [[XGSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)avatarButtonClick:(UIButton *)sender {
    if (_isHaveLogin) {
        [self pushToEditInfoViewController];
    } else {
        [self pushToLoginViewControllerWithCallback:nil];
    }
}

- (void)loginButtonClick:(UIButton *)sender {
    [self pushToLoginViewControllerWithCallback:nil];
}

// 我的关注
- (void)myFollowButtonClick:(UIButton *)sender {
    
}

- (void)myHistoryButtonClick:(UIButton *)sender {
    
}

#pragma mark - TableViewCell TapAction

- (void)didTapInfoView:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_infoView];
    if (CGRectContainsPoint(CGRectMake(0, 0, _infoView.height, _infoView.width/2), point)) {
        if (_isHaveLogin) {
            [self pushToEditInfoViewController];
        } else {
            [self pushToLoginViewControllerWithCallback:nil];
        }
    }
}

- (void)didTapPhoneCell {
    //    if (@available(iOS 10.0, *)) {
    //        [XZYAnalyticsManager callTelephone:self.hotLineNumber targetId:nil];
    //    } else {
    //        XZYAlertView *alertView = [[XZYAlertView alloc] initWithStyle:XZYAlertViewStyleNormal title:nil message:self.hotLineNumber cancleButtonTitle:@"取消" sureButtonTitle:@"呼叫" finishOnclickBlock:^(NSInteger index) {
    //            if (index) {
    //                [XZYAnalyticsManager callTelephone:self.hotLineNumber targetId:nil];
    //            }
    //        }];
    //        [alertView showAlertView];
    //    }
}

- (void)didTapFeedbackCell {
    
}

- (void)didTapRecommondCell {
    //    XZYShareViewController *vc = [[XZYShareViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTapInviteCodeCell {
    //    XZYInviteCodeViewController *vc = [XZYInviteCodeViewController new];
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSourceArray.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
    //    NSArray *arr = [self.dataSourceArray objectAtIndex:section];
    //    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XGMineListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    NSDictionary *dataDict = [self.dataSourceArray safeValue:indexPath.row];
    cell.titleText = [dataDict safeValue:@"title"];
    if ([dataDict[@"id"] isEqualToString:@"sevice"] && kScreenWidth >= 375.0) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor xg_colorWithHexString:@"999999"];
        cell.rightView = label;
    } else {
        [cell.rightView removeFromSuperview];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *grayView = [UIView new];
    grayView.backgroundColor = [UIColor xg_colorWithHexString:@"FAFAFA"];
    return grayView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDict = [self.dataSourceArray safeValue:indexPath.row];
    NSString *iD = [dataDict safeValue:@"id"];
    if ([iD isEqualToString:@"recommend"]) { /*xg< 推荐给好友 */
        [self didTapRecommondCell];
    } else if ([iD isEqualToString:@"feedback"]) { /*xg< 意见反馈 */
        [self didTapFeedbackCell];
    } else if ([iD isEqualToString:@"sevice"]) { //拨打电话
        [self didTapPhoneCell];
    } else if ([iD isEqualToString:@"inviteCode"]) { //邀请码
        [self didTapInviteCodeCell];
    }
}

#pragma mark - UI

- (void)setupUI {
    self.navigationBarView.hidden = YES;
    UIView *tableViewHeader = [UIView new];
    tableViewHeader.backgroundColor = [UIColor whiteColor];
    tableViewHeader.frame = CGRectMake(0, 0, kScreenWidth, 165 + 90 + 10);
    
    _infoView = ({
        UIView *view = [UIView new];
        [tableViewHeader addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(tableViewHeader);
            make.height.mas_equalTo(165 + 16);
        }];
        
        CAGradientLayer *layer = [CAGradientLayer new];
        layer.colors = @[(__bridge id)[UIColor xg_colorWithHexString:@"E40204"].CGColor,
                         (__bridge id)[UIColor xg_colorWithHexString:@"EA5D5C"].CGColor];
        layer.startPoint = CGPointMake(0, 0.5);
        layer.endPoint = CGPointMake(1, 0.5);
        layer.frame = CGRectMake(0, 0, tableViewHeader.width, 165 + 16);
        [view.layer insertSublayer:layer atIndex:0];
        
        UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(didTapInfoView:)];
        [view addGestureRecognizer:tap];
        view;
    });
    
    _settingButton = ({
        UIButton *btn = [UIButton new];
        [_infoView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoView).mas_offset(kStatusBarHeight + 17);
            make.trailing.offset(-22);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        btn.xg_normalImage = [UIImage imageNamed:@"mine_setting_icon"];
        [btn xg_addTapAction:@selector(settingButtonClick:) target:self];
        btn;
    });
    
    _avatarShadow = ({
        UIImageView *view = [UIImageView new];
        [self.infoView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(15);
            make.top.offset(48);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(66);
        }];
        
        view.image = [UIImage imageNamed:@"mine_avatar_shadow"];
        view;
    });
    
    _avatarImageView = ({
        UIImageView *imgView = [UIImageView new];
        [self.infoView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarShadow).offset(3);
            make.centerX.equalTo(self.avatarShadow);
            make.width.height.mas_equalTo(54);
        }];
        imgView.layer.cornerRadius = 27;
        imgView.clipsToBounds = YES;
        imgView.image = [UIImage imageNamed:@"mine_avatar_placeholder"];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(avatarButtonClick:)];
        [imgView addGestureRecognizer:tap];
        imgView;
    });
    
    _loginButton = ({
        UIButton *btn = [UIButton new];
        [self.infoView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.avatarShadow);
            make.leading.equalTo(self.avatarShadow.mas_trailing).offset(20);
        }];
        btn.xg_normalTitle = @"登录\\注册";
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        btn.xg_normalTitleColor = [UIColor xg_colorWithHexString:@"FFFFFF"];
        [btn xg_addTapAction:@selector(loginButtonClick:) target:self];
        btn;
    });
    
    _nicknameLabel = ({
        UILabel *label = [UILabel new];
        [self.infoView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView);
            make.leading.equalTo(self.avatarShadow.mas_trailing).offset(20);
        }];
        label.font =  [UIFont systemFontOfSize:20];
        label.textColor = [UIColor xg_colorWithHexString:@"FFFFFF"];
        label;
    });
    
    _editInfoButton = ({
        UIButton *btn = [UIButton new];
        [self.infoView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.avatarShadow);
            make.leading.equalTo(self.nicknameLabel);
        }];
        btn.xg_normalTitle = @" 个人信息";
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.xg_normalImage = [UIImage imageNamed:@"mine_editinfo_icon"];
        btn.xg_normalTitleColor = [UIColor xg_colorWithHexString:@"FFFFFF"];
        [btn xg_addTapAction:@selector(pushToEditInfoViewController) target:self];
        btn;
    });
    
    _importantFeaturesView = ({
        UIView *view = [UIView new];
        [tableViewHeader addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tableViewHeader).offset(165);
            make.leading.trailing.equalTo(tableViewHeader);
            make.height.mas_equalTo(90);
        }];
        view.backgroundColor = [UIColor whiteColor];
        
        CGRect pathRect = CGRectMake(0, 0, tableViewHeader.width, 90);
        UIRectCorner rectCorner = UIRectCornerTopLeft|UIRectCornerTopRight;
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:pathRect
                                                byRoundingCorners:rectCorner
                                                      cornerRadii:CGSizeMake(16, 16)].CGPath;
        view.layer.mask = shapeLayer;
        view.layer.masksToBounds = YES;
        view;
    });
    
    UIView *grayView = [UIView new];
    [tableViewHeader addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.importantFeaturesView.mas_bottom);
        make.leading.trailing.equalTo(tableViewHeader);
        make.height.mas_equalTo(10);
    }];
    
    _findHouseButton = ({
        UIButton *btn = [self createButtonWithTitle:@"帮我选址"
                                               icon:@"mine_findhouse_icon"
                                             action:@selector(findHouseButtonClick:)];
        [self.importantFeaturesView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.importantFeaturesView);
        }];
        btn;
    });
    
    _HelpMeRentOrSellButton = ({
        UIButton *btn = [self createButtonWithTitle:@"帮我租售"
                                               icon:@"mine_rentOrSell_icon"
                                             action:@selector(helpMeRentOrSellButtonClick:)];
        [self.importantFeaturesView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.findHouseButton.mas_trailing);
            make.top.bottom.equalTo(self.importantFeaturesView);
            make.width.equalTo(self.findHouseButton);
        }];
        btn;
    });
    
    _myFollowButton = ({
        UIButton *btn = [self createButtonWithTitle:@"我的关注"
                                               icon:@"mine_follow_icon"
                                             action:@selector(myFollowButtonClick:)];
        [self.importantFeaturesView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.equalTo(self.importantFeaturesView);
            make.leading.equalTo(self.HelpMeRentOrSellButton.mas_trailing);
            make.width.equalTo(self.HelpMeRentOrSellButton);
        }];
        btn;
    });
    
    _tableView = ({
        UITableView *tableView = [UITableView new];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView.tableHeaderView = tableViewHeader;
        tableView.backgroundColor = [UIColor xg_colorWithHexString:@"FAFAFA"];
        tableView.separatorColor = [UIColor xg_colorWithHexString:@"E9E9E9"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.bounces = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView registerClass:[XGMineListCell class] forCellReuseIdentifier:identifer];
        tableView;
    });
    [self scrollViewContentInsetAdjustmentNever:self.tableView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (UIButton *)createButtonWithTitle:(NSString *)title
                               icon:(NSString *)iconName
                             action:(SEL)action {
    UIButton *btn = [UIButton new];
    [btn xg_layoutButtonWithImageStyle:XGButtonImageStyleTop imageTitleToSpace:12];
    btn.xg_normalTitle = title;
    btn.titleLabel.font = [UIFont xg_pingFangFontOfSize:12];
    btn.xg_normalImage = [UIImage imageNamed:iconName];
    btn.xg_normalTitleColor = [UIColor xg_colorWithHexString:@"666666"];
    [btn xg_addTapAction:action target:self];
    return btn;
}

#pragma mark - Getter&Setter

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithObjects:
                            @{@"imageName":@"mine_sevice_icon", @"title":@"免费客服热线(8:30-18:00)",@"id":@"sevice"},
                            @{@"imageName":@"mine_feeback_icon", @"title":@"反馈建议",@"id":@"feedback"},
                            @{@"imageName":@"mine_recommend_icon",@"title":@"推荐给好友",@"id":@"recommend"},
                            @{@"imageName":@"mine_invite_icon", @"title":@"填写邀请码",@"id":@"inviteCode"},nil];
    }
    return _dataSourceArray;
}

@end
