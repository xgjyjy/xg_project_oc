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

@interface XGFeedbackViewController ()<XGPhotoBrowserViewDelegate,XGEmailManagerDelegate>

/// 容器
@property (nonatomic, strong) UIScrollView *contentScrollView;

/// 意见或建议
@property (nonatomic, strong) UIView *opinionOrSuggestionView;

/// 意见或建议的输入框
@property (nonatomic, strong) XGTextView *inputTextView;

/// 图片选择器
@property (nonatomic, strong) XGPhotoBrowserView *pictureSelectorView;

/// 反馈类型
@property (nonatomic, strong) UIView *feedbackTypeView;

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
    [self showToast:@"提交成功"];
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
    [XGEmailManager shareInstance].emailSubject = [NSString stringWithFormat:@"[%@][%@][联系方式:%@]",appName,self.feedbackTypeString,contact];
    [XGEmailManager shareInstance].delegate = self;
    [[XGEmailManager shareInstance] sendEmailWithContent:self.inputTextView.text imageDatas:imageMuDatas imageNames:imageMuNames];
}

#pragma mark - PublicMethods

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
        make.top.leading.offset(15);
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
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _contentScrollView;
}

- (UIView *)opinionOrSuggestionView {
    if (!_opinionOrSuggestionView) {
        _opinionOrSuggestionView = [[UIView alloc] initWithFrame:CGRectZero];
        _opinionOrSuggestionView.backgroundColor = [UIColor whiteColor];
        _opinionOrSuggestionView.layer.masksToBounds = YES;
        _opinionOrSuggestionView.layer.cornerRadius = 2;
        _opinionOrSuggestionView.layer.borderColor = [UIColor xg_separatorLineColor].CGColor;
        _opinionOrSuggestionView.layer.borderWidth = 0.5;
    }
    return _opinionOrSuggestionView;
}

- (XGTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[XGTextView alloc] initWithFrame:CGRectZero];
        _inputTextView.backgroundColor = self.opinionOrSuggestionView.backgroundColor;
        _inputTextView.placeholder = @"请填写您的意见或建议!";
        _inputTextView.maxCount = 1000;
    }
    return _inputTextView;
}

- (XGPhotoBrowserView *)pictureSelectorView {
    if (!_pictureSelectorView) {
        _pictureSelectorView = [[XGPhotoBrowserView alloc] initWithFrame:CGRectZero];
        _pictureSelectorView.superController = self;
        _pictureSelectorView.delegate = self;
        _pictureSelectorView.backgroundColor = [UIColor greenColor];
    }
    return _pictureSelectorView;
}

- (UIView *)feedbackTypeView {
    if (!_feedbackTypeView) {
        _feedbackTypeView = [[UIView alloc] initWithFrame:CGRectZero];
        _feedbackTypeView.backgroundColor = [UIColor whiteColor];
        _feedbackTypeView.layer.masksToBounds = YES;
        _feedbackTypeView.layer.cornerRadius = 2;
        _feedbackTypeView.layer.borderColor = [UIColor xg_separatorLineColor].CGColor;
        _feedbackTypeView.layer.borderWidth = 0.5;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"请选择反馈类型";
        label.textColor = [UIColor xg_blackColor];
        label.font = [UIFont xg_pingFangFontOfSize:15];
        [_feedbackTypeView addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.offset(15);
        }];
        
        UIView *tagView = [[UIView alloc] initWithFrame:CGRectZero];
        tagView.backgroundColor = [UIColor yellowColor];
        [_feedbackTypeView addSubview:tagView];
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(15);
            make.leading.offset(15);
            make.trailing.bottom.offset(-15);
            make.height.equalTo(@50);
        }];
    }
    return _feedbackTypeView;
}

- (XGTextField *)contactDetailsTextField {
    if (!_contactDetailsTextField) {
        _contactDetailsTextField = [[XGTextField alloc] initWithFrame:CGRectZero];
        _contactDetailsTextField.matchRuleType = 0;
        _contactDetailsTextField.backgroundColor = [UIColor whiteColor];
        _contactDetailsTextField.placeholder = @"请填写您的QQ或手机或邮箱";
        _contactDetailsTextField.maxCount = 5;
        _contactDetailsTextField.layer.masksToBounds = YES;
        _contactDetailsTextField.layer.cornerRadius = 2;
        _contactDetailsTextField.layer.borderColor = [UIColor xg_separatorLineColor].CGColor;
        _contactDetailsTextField.layer.borderWidth = 0.5;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 1)];
        _contactDetailsTextField.leftView = leftView;
        _contactDetailsTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _contactDetailsTextField;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.backgroundColor = [UIColor whiteColor];
        _submitButton.xg_normalTitle = @"提交";
        _submitButton.xg_normalTitleColor = [UIColor xg_blackColor];
        _submitButton.titleLabel.font = [UIFont xg_pingFangFontOfSize:15];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 2;
        [_submitButton xg_addTapAction:@selector(submitButtonAction) target:self];
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
