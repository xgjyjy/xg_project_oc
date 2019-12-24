//
//  UIButton+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "UIButton+XGAdd.h"

@implementation UIButton (XGAdd)

#pragma mark - Title

- (void)setXg_normalTitle:(NSString *)xg_normalTitle {
    [self setTitle:xg_normalTitle forState:UIControlStateNormal];
}

- (NSString *)xg_normalTitle {
    return [self titleForState:UIControlStateNormal];
}

- (void)setXg_highlightedTitle:(NSString *)xg_highlightedTitle {
    [self setTitle:xg_highlightedTitle forState:UIControlStateHighlighted];
}

- (NSString *)xg_highlightedTitle {
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setXg_disabledTitle:(NSString *)xg_disabledTitle {
    [self setTitle:xg_disabledTitle forState:UIControlStateDisabled];
}

- (NSString *)xg_disabledTitle {
    return [self titleForState:UIControlStateDisabled];
}

- (void)setXg_selectedTitle:(NSString *)xg_selectedTitle {
    [self setXg_selectedTitle:xg_selectedTitle];
}

- (NSString *)xg_selectedTitle {
    return [self titleForState:UIControlStateSelected];
}


#pragma mark - TitleColor

- (void)setXg_normalTitleColor:(UIColor *)xg_normalTitleColor {
    [self setTitleColor:xg_normalTitleColor forState:UIControlStateNormal];
}

- (UIColor *)xg_normalTitleColor {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setXg_highlightedTitleColor:(UIColor *)xg_highlightedTitleColor {
    [self setTitleColor:xg_highlightedTitleColor forState:UIControlStateHighlighted];
}

- (UIColor *)xg_highlightedTitleColor {
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setXg_disabledTitleColor:(UIColor *)xg_disabledTitleColor {
    [self setTitleColor:xg_disabledTitleColor forState:UIControlStateDisabled];
}

- (UIColor *)xg_disabledTitleColor {
    return [self titleColorForState:UIControlStateDisabled];
}

- (void)setXg_selectedTitleColor:(UIColor *)xg_selectedTitleColor {
    [self setTitleColor:xg_selectedTitleColor forState:UIControlStateSelected];
}

- (UIColor *)xg_selectedTitleColor {
    return [self titleColorForState:UIControlStateSelected];
}

#pragma mark - Image

- (void)setXg_normalImage:(UIImage *)xg_normalImage {
    [self setImage:xg_normalImage forState:UIControlStateNormal];
}

- (UIImage *)xg_normalImage {
    return [self imageForState:UIControlStateNormal];
}

- (void)setXg_highlightedImage:(UIImage *)xg_highlightedImage {
    [self setImage:xg_highlightedImage forState:UIControlStateHighlighted];
}

- (UIImage *)xg_highlightedImage {
    return [self imageForState:UIControlStateHighlighted];
}

- (void)setXg_disabledImage:(UIImage *)xg_disabledImage {
    [self setImage:xg_disabledImage forState:UIControlStateDisabled];
}

- (UIImage *)xg_disabledImage {
    return [self imageForState:UIControlStateDisabled];
}

- (void)setXg_selectedImage:(UIImage *)xg_selectedImage {
    [self setImage:xg_selectedImage forState:UIControlStateSelected];
}

- (UIImage *)xg_selectedImage {
    return [self imageForState:UIControlStateSelected];
}


#pragma mark - BackgroundImage

- (void)setXg_normalBackgroundImage:(UIImage *)xg_normalBackgroundImage {
    [self setBackgroundImage:xg_normalBackgroundImage forState:UIControlStateNormal];
}

- (UIImage *)xg_normalBackgroundImage {
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setXg_highlightedBackgroundImage:(UIImage *)xg_highlightedBackgroundImage {
    [self setBackgroundImage:xg_highlightedBackgroundImage forState:UIControlStateHighlighted];
}

- (UIImage *)xg_highlightedBackgroundImage {
    return [self backgroundImageForState:UIControlStateHighlighted];
}

- (void)setXg_disabledBackgroundImage:(UIImage *)xg_disabledBackgroundImage {
    [self setBackgroundImage:xg_disabledBackgroundImage forState:UIControlStateDisabled];
}

- (UIImage *)xg_disabledBackgroundImage {
    return [self backgroundImageForState:UIControlStateDisabled];
}

- (void)setXg_selectedBackgroundImage:(UIImage *)xg_selectedBackgroundImage {
    [self setBackgroundImage:xg_selectedBackgroundImage forState:UIControlStateSelected];
}

- (UIImage *)xg_selectedBackgroundImage {
    return [self backgroundImageForState:UIControlStateSelected];
}


#pragma mark - Function

- (void)xg_addTapAction:(SEL)action target:(id)target {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)xg_layoutButtonWithImageStyle:(XGButtonImageStyle)style imageTitleToSpace:(CGFloat)space {
    //1、获取imageView和titleLabel的高和宽
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat titleWidth = self.titleLabel.frame.size.width;
    CGFloat titleHeight = self.titleLabel.frame.size.height;
    
    //2、初始化一个内偏移
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    
    //3、不同的样式处理不同的内偏移
    switch (style) {
        case XGButtonImageStyleTop:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, titleHeight + space / 2.0, -titleWidth);
            titleEdgeInsets = UIEdgeInsetsMake(imageHeight + space / 2.0, -imageWidth, 0, 0);
            break;
        case XGButtonImageStyleLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, space / 2.0);
            titleEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, 0);
            break;
        case XGButtonImageStyleBottom:
            imageEdgeInsets = UIEdgeInsetsMake(titleHeight + space / 2.0, 0, 0, -titleWidth);
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, imageHeight + space / 2, 0);
            break;
        case XGButtonImageStyleRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + space / 2.0, 0, -titleWidth);
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - space / 2.0, 0, imageWidth);
            break;
        default:
            break;
    }
    //4、赋值
    self.imageEdgeInsets = imageEdgeInsets;
    self.titleEdgeInsets = titleEdgeInsets;
}

- (void)xg_imagePositionStyle:(XGButtonImageStyle)imagePositionStyle
                      spacing:(CGFloat)spacing
           imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock {
    imagePositionBlock(self);
    
    if (imagePositionStyle == XGButtonImageStyleLeft) {
        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        } else {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, - 0.5 * spacing, 0, 0.5 * spacing);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5 * spacing, 0, - 0.5 * spacing);
        }
    } else if (imagePositionStyle == XGButtonImageStyleRight) {
        CGFloat imageW = self.imageView.image.size.width;
        CGFloat titleW = self.titleLabel.frame.size.width;
        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW + spacing, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, 0, 0);
        } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleW);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageW + spacing);
        } else {
            CGFloat imageOffset = titleW + 0.5 * spacing;
            CGFloat titleOffset = imageW + 0.5 * spacing;
            self.imageEdgeInsets = UIEdgeInsetsMake(0, imageOffset, 0, - imageOffset);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
        }
    } else if (imagePositionStyle == XGButtonImageStyleTop) {
        CGFloat imageW = self.imageView.frame.size.width;
        CGFloat imageH = self.imageView.frame.size.height;
        CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
        CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;
        self.imageEdgeInsets = UIEdgeInsetsMake(- titleIntrinsicContentSizeH - spacing, 0, 0, - titleIntrinsicContentSizeW);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, - imageH - spacing, 0);
    } else if (imagePositionStyle == XGButtonImageStyleBottom) {
        CGFloat imageW = self.imageView.frame.size.width;
        CGFloat imageH = self.imageView.frame.size.height;
        CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
        CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;
        self.imageEdgeInsets = UIEdgeInsetsMake(titleIntrinsicContentSizeH + spacing, 0, 0, - titleIntrinsicContentSizeW);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, imageH + spacing, 0);
    }
}

@end
