//
//  XGCustomTagView.h
//  xuanzhiyi
//
//  Created by 伙伴行 on 2019/12/26.
//  Copyright © 2019 选址易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGTagView.h"

NS_ASSUME_NONNULL_BEGIN

@class XGCustomTagView;
@protocol XGCustomTagViewDelegate <NSObject>

@optional

/// 单选
/// @param tagView 当前view
/// @param tagModel 选中的标签的数据
- (void)xg_customTagView:(XGCustomTagView *)tagView didSelectedTag:(nullable XGTagModel *)tagModel;

/// 多选
/// @param tagView 当前view
/// @param tagModels 多次选中的标签的数据集合
- (void)xg_customTagView:(XGCustomTagView *)tagView didSelectedTags:(nullable NSArray <XGTagModel *> *)tagModels;

@end

@interface XGCustomTagView : UIView

/// 代理
@property (nonatomic,   weak) id<XGCustomTagViewDelegate> delegate;

/// title的四个方向的边距 (默认 15, 15, 0, 15  bottom 请不要设值,用tagView的top来设置)
@property (nonatomic, assign) UIEdgeInsets titleInsets;

/// tagView的四个方向的边距 (默认15,15, 15, 15.  top是相对于titleLabel的bottom的)
@property (nonatomic, assign) UIEdgeInsets tagViewInsets;

/// title的text
@property (nonatomic,   copy) NSString *text;

/// 输入框的高度(默认30)
@property (nonatomic, assign) CGFloat inputHeight;

/// 输入框的四个方向的边距 (默认15,15, 15, 15.  top是相对于tagView的bottom的)
@property (nonatomic, assign) UIEdgeInsets inputViewInsets;

/// 是否显示输入框(默认NO不显示)
@property (nonatomic, assign, getter=isDisplayInputView) BOOL displayInputView;

/// 输入框
@property (nonatomic, strong, readonly) UITextField *textField;

/// title
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// tagView
@property (nonatomic, strong, readonly) XGTagView *tagView;

/// 显示tagView
/// @param textArray 数据源
/// @param tagConfig 配置
- (void)displayTagViewWithTextArray:(NSArray <NSString *> *)textArray tagConfig:(XGTagConfig *)tagConfig;

@end

NS_ASSUME_NONNULL_END
