//
//  UIButton+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XGButtonImageStyle){
    XGButtonImageStyleTop = 0,  //图片在上，文字在下
    XGButtonImageStyleLeft,     //图片在左，文字在右
    XGButtonImageStyleBottom,   //图片在下，文字在上
    XGButtonImageStyleRight     //图片在右，文字在左
};

@interface UIButton (XGAdd)

@property (nonatomic, weak) NSString *xg_normalTitle;
@property (nonatomic, weak) NSString *xg_highlightedTitle;
@property (nonatomic, weak) NSString *xg_disabledTitle;
@property (nonatomic, weak) NSString *xg_selectedTitle;

@property (nonatomic, weak) UIColor *xg_normalTitleColor;
@property (nonatomic, weak) UIColor *xg_highlightedTitleColor;
@property (nonatomic, weak) UIColor *xg_disabledTitleColor;
@property (nonatomic, weak) UIColor *xg_selectedTitleColor;

@property (nonatomic, weak) UIImage *xg_normalImage;
@property (nonatomic, weak) UIImage *xg_highlightedImage;
@property (nonatomic, weak) UIImage *xg_disabledImage;
@property (nonatomic, weak) UIImage *xg_selectedImage;

@property (nonatomic, weak) UIImage *xg_normalBackgroundImage;
@property (nonatomic, weak) UIImage *xg_highlightedBackgroundImage;
@property (nonatomic, weak) UIImage *xg_disabledBackgroundImage;
@property (nonatomic, weak) UIImage *xg_selectedBackgroundImage;

/**
 添加UIControlEventTouchUpInside的事件

 @param action action
 @param target target
 */
- (void)xg_addTapAction:(SEL)action target:(id)target;

/**
 设置button的imageView和titleLabel的布局样式及它们的间距
 @param style imageView和titleLabel的布局样式
 @param space imageView和titleLabel的间距
 */
- (void)xg_layoutButtonWithImageStyle:(XGButtonImageStyle)style
                    imageTitleToSpace:(CGFloat)space;

/**
 *  设置图片与文字样式
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 *  @param imagePositionBlock     在此 Block 中设置按钮的图片、文字以及 contentHorizontalAlignment 属性
 */
- (void)xg_imagePositionStyle:(XGButtonImageStyle)imagePositionStyle
                      spacing:(CGFloat)spacing
           imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock;

@end

NS_ASSUME_NONNULL_END
