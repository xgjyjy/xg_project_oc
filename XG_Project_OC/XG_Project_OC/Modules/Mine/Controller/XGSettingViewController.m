//
//  XGSettingViewController.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/9.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGSettingViewController.h"
#import "XGFeedbackViewController.h"
#import "XGAboutUsViewController.h"
#import "XGWebViewController.h"
#import "XGUserAgreementViewController.h"
#import "XGSkinViewController.h"
#import "XGSiriViewController.h"
#import "XGLanguageViewController.h"
#import "XGSettingListCell.h"
#import <SDImageCache.h>
#import "NSDictionary+XGAdd.h"
#import "NSArray+XGAdd.h"
#import "UIButton+XGAdd.h"

@interface XGSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *logOutButton;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation XGSettingViewController

#pragma mark - LifeCycle

- (void)dealloc{
    XLog(@"当前界面销毁了%@",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"设置"];
    [self showNavigationBarBackButton];
    self.view.backgroundColor = [UIColor xg_backgroundColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logOutButton];
    [self layoutPageSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.logOutButton.hidden = ![[XZYLoginManager sharedManager] isLogined];
}

#pragma mark - TargetAction

- (void)logOutButtonClick:(UIButton *)sender {
    //    if ([[XZYLoginManager sharedManager] logoutWithType:XZYLogoutTypeManually]) {
    //        sender.hidden = YES;
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSourceArray safeValue:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XGSettingListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGSettingListCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor xg_contentColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDict = self.dataSourceArray[indexPath.section][indexPath.row];
    cell.titleText = [dataDict safeValue:@"title"];
    cell.arrowTitle = [dataDict safeValue:@"arrowTitle"];
    cell.hideLine = indexPath.row == [self.dataSourceArray[indexPath.section] count] - 1;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDict = self.dataSourceArray[indexPath.section][indexPath.row];
    NSString *iD = [dataDict safeValue:@"id"];
    if ([iD isEqualToString:@"cleanCache"]) { /** 清除缓存 */
        XGSettingListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell clearImageCache:^{
            [self showToast:@"清理成功"];
        }];
    } else if ([iD isEqualToString:@"aboutUs"]) { /** 关于我们 */
        [self.navigationController pushViewController:[XGAboutUsViewController new] animated:YES];
    } else if ([iD isEqualToString:@"privacyPolicy"]) { /** 隐私政策 */
        XGWebViewController *privacyPolicyVc = [[XGWebViewController alloc] initWithVcTitle:@"晓哥隐私政策" htmlName:@"privacyPolicy"];
        [self.navigationController pushViewController:privacyPolicyVc animated:YES];
    } else if ([iD isEqualToString:@"goToScore"]) { /** 去评分 */
        NSString *urlString = @"https://itunes.apple.com/us/app/twitter/id1159301055?mt=8&action=write-review";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else if ([iD isEqualToString:@"feedback"]) { /** 意见反馈 */
        [self.navigationController pushViewController:[XGFeedbackViewController new] animated:YES];
    } else if ([iD isEqualToString:@"siri"]) { /** Siri 快捷方式 */
        [self.navigationController pushViewController:[XGSiriViewController new] animated:YES];
    } else if ([iD isEqualToString:@"skin"]) { /** 个性皮肤 */
        [self.navigationController pushViewController:[XGSkinViewController new] animated:YES];
    } else if ([iD isEqualToString:@"language"]) { /** 多语言 */
        [self.navigationController pushViewController:[XGLanguageViewController new] animated:YES];
    } else if ([iD isEqualToString:@"userAgreement"]) { /** 用户使用协议 */
        [self.navigationController pushViewController:[XGUserAgreementViewController new] animated:YES];
    }
}

#pragma mark - PrivateMethods


#pragma mark - LayoutPageSubviews

- (void)layoutPageSubviews {
    [self.logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(30);
        make.trailing.bottom.offset(-30);
        make.height.mas_equalTo(45);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.right.equalTo(self.view);
        make.top.offset(kContentY);
        make.bottom.equalTo(self.logOutButton.mas_top).offset(-30);
    }];
}

#pragma mark - Getter&Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[XGSettingListCell class] forCellReuseIdentifier:NSStringFromClass([XGSettingListCell class])];
    }
    return _tableView;
}

- (UIButton *)logOutButton {
    if (!_logOutButton) {
        _logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutButton.titleLabel.font = [UIFont xg_pingFangFontOfSize:15];
        _logOutButton.hidden = YES;
        _logOutButton.xg_normalTitle = @"退出登录";
        [_logOutButton addTarget:self action:@selector(logOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logOutButton;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        NSString *cacheSize = [NSString stringWithFormat:@"%.1fM",[SDImageCache sharedImageCache].getSize / 1024.0 / 1024.0];
        _dataSourceArray = [NSMutableArray arrayWithObjects:
                            @[@{@"title":@"清理缓存",@"arrowTitle": cacheSize, @"id":@"cleanCache"},
                              @{@"title":@"个性皮肤",@"id":@"skin"},
                              @{@"title":@"多语言",@"id":@"language"}],
                            @[@{@"title":@"关于我们",@"id":@"aboutUs"},
                              @{@"title":@"隐私政策",@"id":@"privacyPolicy"},
                              @{@"title":@"用户协议",@"id":@"userAgreement"},
                              @{@"title":@"意见反馈",@"id":@"feedback"},
                              @{@"title":@"去评分",@"id":@"goToScore"}],
                            @[@{@"title":@"Siri 快捷方式",@"id":@"siri"}],nil];
    }
    return _dataSourceArray;
}

@end
