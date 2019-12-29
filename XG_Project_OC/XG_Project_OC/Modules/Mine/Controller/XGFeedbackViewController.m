//
//  XGFeedbackViewController.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/21.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGFeedbackViewController.h"
#import "XGPhotoBrowserView.h"
#import "XGTextView.h"
#import "XGTextField.h"
#import "UIButton+XGAdd.h"
#import "XGEmailManager.h"
#import "XGCustomTagView.h"
#import "UIColor+XGAdd.h"

@interface XGFeedbackViewController ()<XGPhotoBrowserViewDelegate,XGEmailManagerDelegate,XGTextViewDelegate,XGCustomTagViewDelegate>

/// 容器
@property (nonatomic, strong) UIScrollView *contentScrollView;

/// 意见或建议
@property (nonatomic, strong) UIView *opinionOrSuggestionView;

/// 意见或建议的输入框
@property (nonatomic, strong) XGTextView *inputTextView;

/// 图片选择器
@property (nonatomic, strong) XGPhotoBrowserView *pictureSelectorView;

/// 反馈类型
@property (nonatomic, strong) XGCustomTagView *feedbackTypeView;

/// 联系方式
@property (nonatomic, strong) XGTextField *contactDetailsTextField;

/// 提交按钮
@property (nonatomic, strong) UIButton *submitButton;

/// 用户选择的图片
@property (nonatomic, strong) NSMutableArray *selectPhotos;

/// 用户选择的反馈类型
@property (nonatomic, assign) NSString *feedbackTypeString;

@end

@implementation XGFeedbackViewController

#pragma mark - LifeCycle

- (void)dealloc{
    XLog(@"当前界面销毁了%@",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _feedbackTypeString = @"用户反馈";
    [self showNavigationBarBackButton];
    [self setTitleText:@"意见反馈"];
    [self initSubviews];
    [self layoutPageSubviews];
}

#pragma mark - XGEmailManagerDelegate

- (void)xg_messageSent:(XGEmailManager *)message {
    [self hideLoading];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"提交成功!\n感谢您的反馈,我们会尽快处理!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVc addAction:okAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)xg_messageFailed:(XGEmailManager *)message error:(NSError *)error {
    [self hideLoading];
    [self showToast:[NSString stringWithFormat:@"提交失败:%@",error]];
}

#pragma mark - XGPhotoBrowserViewDelegate

- (void)xg_photoBrowserView:(XGPhotoBrowserView *)view didSelectPhotos:(NSArray<UIImage *> *)photos urls:(NSArray<NSString *> *)urls {
    if (photos.count == 0) {
        return;
    }
    [self.selectPhotos removeAllObjects];
    [self.selectPhotos addObjectsFromArray:photos];
}

#pragma mark - XGTextViewDelegate

- (void)xg_textViewDidChange:(XGTextView *)textView {
    self.submitButton.backgroundColor = textView.text.length > 0 ? [UIColor xg_redColor] : [UIColor whiteColor];
    self.submitButton.xg_normalTitleColor = textView.text.length > 0 ? [UIColor whiteColor] : [UIColor xg_lightGrayColor];
}

#pragma mark - XGCustomTagViewDelegate

- (void)xg_customTagView:(XGCustomTagView *)tagView didSelectedTag:(XGTagModel *)tagModel {
    self.feedbackTypeString = tagModel.tagText;
}

#pragma mark - TargetAction

- (void)submitButtonAction {
    if (self.inputTextView.text.length == 0) {
        [self showToast:@"请填写您的意见或建议"];
        return;
    }
    if (!self.feedbackTypeString.xg_isString) {
        [self showToast:@"请选择反馈类型"];
        return;
    }
    if (self.contactDetailsTextField.text.xg_isString &&
        ![XGMatchManager isEmailOrPhoneNumberOrQQ:self.contactDetailsTextField.text]) {
        [self showToast:@"请输入合法的QQ或手机或邮箱"];
        return;
    }
    [self showLoading:@"提交中..."];
    /** 将图片转成data  */
    NSMutableArray *imageMuDatas = [NSMutableArray array];
    NSMutableArray *imageMuNames = [NSMutableArray array];
    if (self.selectPhotos.count > 0) {
        for (int i = 0; i < self.selectPhotos.count; i++) {
            UIImage *image = [self.selectPhotos objectAtIndex:i];
            NSData *imageData = UIImageJPEGRepresentation(image,0.5f);
            [imageMuDatas addObject:imageData];
            [imageMuNames addObject:[NSString stringWithFormat:@"IMAGE_%d",i]];
        }
    }
    /** 发送邮件 */
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *contact = self.contactDetailsTextField.text.length > 0 ? self.contactDetailsTextField.text : @"未填写";
    NSString *content = [NSString stringWithFormat:@"[%@][联系方式:%@]\n内容:%@",self.feedbackTypeString,contact,self.inputTextView.text];
    [XGEmailManager shareInstance].emailSubject = [NSString stringWithFormat:@"[%@]的意见反馈",appName];
    [XGEmailManager shareInstance].delegate = self;
    [[XGEmailManager shareInstance] sendEmailWithContent:content imageDatas:imageMuDatas imageNames:imageMuNames];
}

#pragma mark - PrivateMethods

- (void)initSubviews {
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.opinionOrSuggestionView];
    [self.opinionOrSuggestionView addSubview:self.inputTextView];
    [self.opinionOrSuggestionView addSubview:self.pictureSelectorView];
    [self.contentScrollView addSubview:self.feedbackTypeView];
    [self.contentScrollView addSubview:self.contactDetailsTextField];
    [self.contentScrollView addSubview:self.submitButton];
}

#pragma mark - LayoutPageSubviews

- (void)layoutPageSubviews {
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kContentY);
        make.leading.trailing.bottom.offset(0);
    }];
    [self.opinionOrSuggestionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(15);
        make.width.equalTo(self.contentScrollView.mas_width).offset(-30);
    }];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.offset(0);
        make.height.equalTo(@150);
    }];
    [self.pictureSelectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextView.mas_bottom);
        make.leading.trailing.bottom.offset(0);
    }];
    [self.feedbackTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.opinionOrSuggestionView.mas_bottom).offset(15);
        make.leading.offset(15);
        make.width.equalTo(self.contentScrollView.mas_width).offset(-30);
    }];
    [self.contactDetailsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackTypeView.mas_bottom).offset(15);
        make.leading.offset(15);
        make.width.equalTo(self.contentScrollView.mas_width).offset(-30);
        make.height.equalTo(@44);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactDetailsTextField.mas_bottom).offset(15);
        make.leading.offset(15);
        make.width.equalTo(self.contentScrollView.mas_width).offset(-30);
        make.bottom.offset(-50);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Getter&Setter

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
            scrollView;
        });
    }
    return _contentScrollView;
}

- (UIView *)opinionOrSuggestionView {
    if (!_opinionOrSuggestionView) {
        _opinionOrSuggestionView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 2;
            view.layer.borderColor = [UIColor xg_separatorLineColor].CGColor;
            view.layer.borderWidth = 0.5;
            view;
        });
    }
    return _opinionOrSuggestionView;
}

- (XGTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = ({
            XGTextView *textView = [[XGTextView alloc] initWithFrame:CGRectZero];
            textView.backgroundColor = self.opinionOrSuggestionView.backgroundColor;
            textView.placeholder = @"请填写您的意见或建议!";
            textView.isHideMaxCount = YES;
            textView.maxCount = 1000;
            textView.delegate = self;
            textView;
        });
    }
    return _inputTextView;
}

- (XGPhotoBrowserView *)pictureSelectorView {
    if (!_pictureSelectorView) {
        _pictureSelectorView = ({
            XGPhotoBrowserView *photoBrowserView = [[XGPhotoBrowserView alloc] initWithFrame:CGRectZero];
            photoBrowserView.maxCount = 5;
            photoBrowserView.columnCount = 5;
            photoBrowserView.superController = self;
            photoBrowserView.delegate = self;
            photoBrowserView;
        });
    }
    return _pictureSelectorView;
}

- (XGCustomTagView *)feedbackTypeView {
    if (!_feedbackTypeView) {
        _feedbackTypeView = ({
            XGCustomTagView *tagView = [[XGCustomTagView alloc] initWithFrame:CGRectZero];
            tagView.delegate = self;
            tagView.backgroundColor = [UIColor whiteColor];
            tagView.text = @"请选择反馈类型";
            tagView.titleLabel.textColor = [UIColor xg_lightGrayColor];
            tagView.titleLabel.font = [UIFont xg_pingFangFontOfSize:15];
            tagView.layer.masksToBounds = YES;
            tagView.layer.cornerRadius = 2;
            tagView.layer.borderColor = [UIColor xg_separatorLineColor].CGColor;
            tagView.layer.borderWidth = 0.5;
            XGTagConfig *config = [[XGTagConfig alloc] init];
            config.tagType = XGTagTypeFixedSize;
            config.lineSpacing = 15;
            config.interitemSpacing = 15;
            CGFloat tagWidth = (kScreenWidth - (3 - 1) * config.interitemSpacing - 15 * 4) / 3;
            config.fixedSize = CGSizeMake(tagWidth, 25);
            config.tagFont = [UIFont xg_pingFangFontOfSize:15];
            config.normalTextColor = [UIColor xg_blackColor];
            config.selectedTextColor = [UIColor xg_redColor];
            config.normalBgColor = [UIColor xg_colorWithHexString:@"#F1F1F1"];
            config.selectedBgColor = [[UIColor xg_redColor] colorWithAlphaComponent:0.05];
            [tagView displayTagViewWithTextArray:@[@"程序bug",@"功能建议",@"内容意见",@"广告问题",@"网络问题",@"其他"] tagConfig:config];
            tagView;
        });
    }
    return _feedbackTypeView;
}

- (XGTextField *)contactDetailsTextField {
    if (!_contactDetailsTextField) {
        _contactDetailsTextField = ({
            XGTextField *textFiled = [[XGTextField alloc] initWithFrame:CGRectZero];
            textFiled.matchRuleType = XGMatchRuleTypeCannotInputChinese;
            textFiled.backgroundColor = [UIColor whiteColor];
            textFiled.placeholder = @"请填写您的QQ或手机或邮箱";
            textFiled.maxCount = 30;
            textFiled.layer.masksToBounds = YES;
            textFiled.layer.cornerRadius = 2;
            textFiled.layer.borderColor = [UIColor xg_separatorLineColor].CGColor;
            textFiled.layer.borderWidth = 0.5;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 1)];
            textFiled.leftView = leftView;
            textFiled.leftViewMode = UITextFieldViewModeAlways;
            textFiled;
        });
    }
    return _contactDetailsTextField;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            button.xg_normalTitle = @"提交";
            button.xg_normalTitleColor = [UIColor lightGrayColor];
            button.titleLabel.font = [UIFont xg_pingFangFontOfSize:15];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 2;
            [button xg_addTapAction:@selector(submitButtonAction) target:self];
            button;
        });
    }
    return _submitButton;
}

- (NSMutableArray *)selectPhotos {
    if (!_selectPhotos) {
        _selectPhotos = [NSMutableArray array];
    }
    return _selectPhotos;
}

@end
