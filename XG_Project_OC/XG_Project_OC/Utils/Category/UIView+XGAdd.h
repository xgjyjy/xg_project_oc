//
//  UIView+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XGAdd)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat X;
@property (nonatomic, assign) CGFloat Y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat right;       // frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat bottom;      // frame.origin.y + frame.size.height

/**
 为UIButton.normalState 或 UIImageView 设置图片

 @param url 图片URLString
 @param placeholderImage 占位图
 */
- (void)hb_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

/**
 为UIButton.normalState 或 UIImageView 设置图片
 
 @param url 图片URLString
 @param placeholderImageName 占图片名
 */
- (void)hb_setImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderImageName;


/**
 为normalState的UIButton 或 UIImageView 设置背景图片

 @param url 图片URLString
 @param placeholderImage 占位图
 */
- (void)hb_setBackgroundImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

/**
 为normalState的UIButton 或 UIImageView 设置背景图片
 
 @param url 图片URLString
 @param placeholderImageName 占位图名
 */
- (void)hb_setBackgroundImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderImageName;

/**
 设置头像, 带默认placeholder
 */
- (void)hb_setAvatarImageWithURL:(NSString *)url;

/**
 给view添加指定边框

 @param view 目标view
 @param rectCorner 边框位置
 @param color 边框颜色
 @param width 边框大小
 */
+ (void)setBorderWithView:(UIView *)view
               rectCorner:(UIRectCorner)rectCorner
              borderColor:(UIColor *)color
              borderWidth:(CGFloat)width;

/**
 给view添加指定圆角

 @param view 目标view
 @param rectCorner 圆角位置
 @param cornerRadius 圆角大小
 */
+ (void)setRoundedcornersWithView:(UIView *)view
               rectCorner:(UIRectCorner)rectCorner
             cornerRadius:(CGFloat)cornerRadius;

/**
 给view添加渐变色

 @param colors 颜色集合
 @param view 需要添加渐变色的view
 */
+ (void)setGradientColorWithColors:(NSArray <UIColor *>*)colors
                            toView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
