//
//  UIView+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "UIView+XGAdd.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSURL+XGAdd.h"

@implementation UIView (XGAdd)

#pragma mark - setter

- (void)setOrigin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    [self setFrame:rect];
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    [self setFrame:rect];
}

- (void)setX:(CGFloat)X {
    CGRect rect = self.frame;
    rect.origin.x = X;
    [self setFrame:rect];
}

- (void)setY:(CGFloat)Y {
    CGRect rect = self.frame;
    rect.origin.y = Y;
    [self setFrame:rect];
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    [self setFrame:rect];
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    [self setFrame:rect];
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    [self setCenter:center];
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    [self setCenter:center];
}

#pragma mark - getter

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)X {
    return self.frame.origin.x;
}

- (CGFloat)Y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)hb_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self;
        [btn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:placeholderImage];
    } else if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)self;
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
    } else {
        // MARK: 这行代码需要测试
        self.layer.contents = (__bridge id)[placeholderImage CGImage];
    }
}

- (void)hb_setImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderImageName {
    UIImage *image = [UIImage imageNamed:placeholderImageName];
    [self hb_setImageWithURL:url placeholderImage:image];
}

- (void)hb_setBackgroundImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    if ([self isKindOfClass:[UIButton class]]) {
        
        UIButton *btn = (UIButton *)self;
        [btn sd_setBackgroundImageWithURL:[[NSURL URLWithString:url] thumbImageURL]
                                 forState:UIControlStateNormal
                         placeholderImage:placeholderImage];
    } else if ([self isKindOfClass:[UIImageView class]]) {
        
        UIImageView *imgView = (UIImageView *)self;
        [imgView sd_setImageWithURL:[[NSURL URLWithString:url] thumbImageURL] placeholderImage:placeholderImage];
    } else {
        XLog(@"不是button或者imageView");
    }
}

- (void)hb_setBackgroundImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderImageName {
    UIImage *image = [UIImage imageNamed:placeholderImageName];
    [self hb_setBackgroundImageWithURL:url placeholderImage:image];
}

- (void)hb_setAvatarImageWithURL:(NSString *)url {
    [self hb_setImageWithURL:url placeholderImageName:@"placeholder_houseDetails_head"];
}

+ (void)setBorderWithView:(UIView *)view
               rectCorner:(UIRectCorner)rectCorner
              borderColor:(UIColor *)color
              borderWidth:(CGFloat)width {
    [self setRoundedcornersWithView:view rectCorner:rectCorner cornerRadius:1];
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = width;
}

+ (void)setRoundedcornersWithView:(UIView *)view
                       rectCorner:(UIRectCorner)rectCorner
                     cornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    //设置大小
    maskLayer.frame = view.bounds;
    
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
}

/** 给view添加渐变色 */
+ (void)setGradientColorWithColors:(NSArray <UIColor *>*)colors toView:(UIView *)view {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.frame = view.bounds;
    gradient.cornerRadius = view.layer.cornerRadius;
    NSMutableArray *newColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [newColors addObject:(id)color.CGColor];
    }
    gradient.colors = newColors;
    [view.layer insertSublayer:gradient atIndex:0];
}

@end
