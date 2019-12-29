//
//  XGTagView.h
//  xuanzhiyi
//
//  Created by 伙伴行 on 2019/12/26.
//  Copyright © 2019 选址易. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 标签类型
typedef NS_ENUM(NSInteger, XGTagType) {
    /// 根据内容自适应大小(默认)
    XGTagTypeAdaptiveSize,
    
    /// 固定大小
    XGTagTypeFixedSize,
};

@class XGTagConfig;
@class XGTagView;
@class XGTagModel;
@protocol XGTagViewDelegate <NSObject>
@optional

/// 单选
/// @param tagView 当前view
/// @param tagModel 选中的标签的数据
- (void)xg_tagView:(XGTagView *)tagView didSelectedTag:(nullable XGTagModel *)tagModel;

/// 多选
/// @param tagView 当前view
/// @param tagModels 多次选中的标签的数据集合
- (void)xg_tagView:(XGTagView *)tagView didSelectedTags:(nullable NSArray <XGTagModel *> *)tagModels;

@end

@interface XGTagView : UIView

/// 代理
@property (nonatomic,   weak) id<XGTagViewDelegate> delegate;

/// 遍历构造器
/// @param textArray 标签文本数组
/// @param tagConfig 标签的配置
- (instancetype)initWithTextArray:(NSArray *)textArray tagConfig:(XGTagConfig *)tagConfig;

/// 单选某个标签
/// @param index 标签的下标
- (void)singleChoiceTagAtIndex:(NSInteger)index;

/// 单选某个标签
/// @param text 标签的title
- (void)singleChoiceTagAtText:(NSString *)text;

/// 多选指定的标签
/// @param indexs 标签的下标集合
- (void)multipleChoiceTagAtIndexs:(NSArray <NSNumber *> *)indexs;

/// 多选指定的标签
/// @param texts 标签的下标text集合
- (void)multipleChoiceTagAtTexts:(NSArray <NSString *> *)texts;

/// 刷新标签的数据源
/// @param textArray 数据源
- (void)reloadDataSoure:(NSArray *)textArray;

/// 取消所有标签的选中状态
- (void)cancelSelected;

/// 显示指定行高的标签
/// @param lineNumber 行数
- (void)displaySpecifiedLineTag:(NSUInteger)lineNumber;

@end

@interface XGTagModel : NSObject

/// 标签的index
@property (nonatomic, assign) NSInteger tagIndex;

/// 标签的text
@property (nonatomic,   copy) NSString *tagText;

/// 标签的选中状态(内部使用,外界请以tagText是否有值,来判断是否选中)
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/// 标签的大小
@property (nonatomic, assign) CGSize tagSize;

@end

@interface XGTagConfig : NSObject

/// 标签类型
@property (nonatomic, assign) XGTagType tagType;

/// 是否可以取消选中状态(默认不可以)
@property (nonatomic, assign, getter=isCancel) BOOL cancel;

/// 是否可以多选(默认不可以)
@property (nonatomic, assign, getter=isCanChooseMultiple) BOOL canChooseMultiple;

/// 是否开启标签的交互状态(默认YES开启)
@property (nonatomic, assign, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;

/// 是否让系统自动计算间距(默认NO不计算)
@property (nonatomic, assign, getter=isSpacingAdaptive) BOOL spacingAdaptive;

/// 标签的固定大小(tagType == XGTagTypeFixedSize时有效)
@property (nonatomic, assign) CGSize fixedSize;

/// 标签的最大宽度(XGTagTypeAdaptiveSize时,可以给个宽度来限制最大宽,记得设置lineBreakMode)
@property (nonatomic, assign) CGFloat tagMaxWidth;

/// 标签默认状态下的背景图片(图片、边框和背景色只能三选一)
@property (nonatomic, strong) UIImage *normalBgImage;

/// 标签选中状态下的背景图片(图片、边框和背景色只能三选一)
@property (nonatomic, strong) UIImage *selectedBgImage;

/// 标签默认状态下的背景色(图片、边框和背景色只能三选一)
@property (nonatomic, strong) UIColor *normalBgColor;

/// 标签选中状态下的背景色(图片、边框和背景色只能三选一)
@property (nonatomic, strong) UIColor *selectedBgColor;

/// 标签默认状态下的边框色(图片、边框和背景色只能三选一)
@property (nonatomic, strong) UIColor *normalBorderColor;

/// 标签选中状态下的边框色(图片、边框和背景色只能三选一)
@property (nonatomic, strong) UIColor *selectedBorderColor;

/// 标签的边框大小
@property (nonatomic, assign) CGFloat borderWidth;

/// 标签默认状态下的文字色
@property (nonatomic, strong) UIColor *normalTextColor;

/// 标签选中状态下的文字色
@property (nonatomic, strong) UIColor *selectedTextColor;

/// 标签的字体大小
@property (nonatomic, strong) UIFont *tagFont;

/// 标签字体...方式
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;

/// 标签label的最大行数
@property (nonatomic, assign) NSInteger numberOfLines;

/// 标签的列间距
@property (nonatomic, assign) CGFloat interitemSpacing;

/// 标签的列间距
@property (nonatomic, assign) CGFloat lineSpacing;

/// 标签的内边距(tagType != XGTagTypeFixedSize时有效)
@property (nonatomic, assign) UIEdgeInsets padding;

/// 标签的圆角大小
@property (nonatomic, assign) CGFloat borderRadius;

@end

NS_ASSUME_NONNULL_END
