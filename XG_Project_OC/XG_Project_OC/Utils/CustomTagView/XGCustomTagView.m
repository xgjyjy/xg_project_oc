//
//  XGCustomTagView.m
//  xuanzhiyi
//
//  Created by 伙伴行 on 2019/12/26.
//  Copyright © 2019 选址易. All rights reserved.
//

#import "XGCustomTagView.h"
#import "XGTagView.h"

@interface XGCustomTagView ()<XGTagViewDelegate>

/// title
@property (nonatomic, strong) UILabel *titleLabel;

/// tagView
@property (nonatomic, strong) XGTagView *tagView;

/// 输入框
@property (nonatomic, strong) UITextField *textField;

@end

@implementation XGCustomTagView

#pragma mark - LifeCycle

- (void)dealloc {
    XLog(@"当前控制器销毁了%@",self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - XGTagViewDelegate

- (void)xg_tagView:(XGTagView *)tagView didSelectedTag:(nullable XGTagModel *)tagModel {
    if ([self.delegate respondsToSelector:@selector(xg_customTagView:didSelectedTag:)]) {
        [self.delegate xg_customTagView:self didSelectedTag:tagModel];
    }
}

- (void)xg_tagView:(XGTagView *)tagView didSelectedTags:(nullable NSArray<XGTagModel *> *)tagModels {
    if ([self.delegate respondsToSelector:@selector(xg_customTagView:didSelectedTags:)]) {
        [self.delegate xg_customTagView:self didSelectedTags:tagModels];
    }
}

#pragma mark - PublicMethods

- (void)setTitleInsets:(UIEdgeInsets)titleInsets {
    _titleInsets = titleInsets;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(titleInsets.top);
        make.leading.offset(titleInsets.left);
        make.trailing.offset(-titleInsets.right);
    }];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = text;
    [self.titleLabel sizeToFit];
}

- (void)displayTagViewWithTextArray:(NSArray<NSString *> *)textArray tagConfig:(XGTagConfig *)tagConfig {
    if (![textArray isKindOfClass:[NSArray class]] || !tagConfig) return;
    if (textArray.count == 0) return;
    XGTagView *tagView = [[XGTagView alloc] initWithTextArray:textArray tagConfig:tagConfig];
    tagView.delegate = self;
    self.tagView = tagView;
    [self addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.tagViewInsets.top);
        make.leading.offset(self.tagViewInsets.left);
        make.trailing.offset(-self.tagViewInsets.right);
        make.bottom.offset(-self.tagViewInsets.bottom);
    }];
}

- (void)setDisplayInputView:(BOOL)displayInputView {
    _displayInputView = displayInputView;
    self.textField.hidden = !displayInputView;
    if (displayInputView) {
        [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(self.tagViewInsets.top);
            make.leading.offset(self.tagViewInsets.left);
            make.trailing.offset(-self.tagViewInsets.right);
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagView.mas_bottom).offset(self.inputViewInsets.top);
            make.leading.offset(self.inputViewInsets.left);
            make.trailing.offset(-self.inputViewInsets.right);
            make.bottom.offset(-self.inputViewInsets.bottom);
            make.height.equalTo(@(self.inputHeight));
        }];
    } else {
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            // 移除所有约束(必须比tagView先设置约束,否则报各种约束警告)
        }];
        [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(self.tagViewInsets.top);
            make.leading.offset(self.tagViewInsets.left);
            make.trailing.offset(-self.tagViewInsets.right);
            make.bottom.offset(-self.tagViewInsets.bottom);
        }];
    }
}

#pragma mark - PrivateMethods

#pragma mark - LayoutPageSubviews

- (void)initSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    self.inputHeight = 30;
    self.titleInsets = UIEdgeInsetsMake(15, 15, 0, 15);
    self.tagViewInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.inputViewInsets = UIEdgeInsetsMake(15, 15, 15, 15);
}

#pragma mark - Getter&Setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label.text = @"自定义label";
            label;
        });
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
            textField.backgroundColor = [UIColor greenColor];
            textField;
        });
    }
    return _textField;
}

@end
