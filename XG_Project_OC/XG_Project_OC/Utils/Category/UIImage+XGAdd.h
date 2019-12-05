//
//  UIImage+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XGAdd)

/**
 按照指定size裁剪图片

 @param width 指定宽
 @param height 指定高
 @return 裁剪好的图片
 */
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height ;

/**
 等比例和指定大小缩放图片

 @param size 指定大小
 @return 裁剪好的图片
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 按照4:3比例裁剪图片

 @return 裁剪好的图片
 */
- (UIImage *)croppedImage;

/**
 按照指定大小和屏幕比列裁剪图片
 
 @param newsize 指定大小
 @return 裁剪好的图片
 */
- (UIImage *)transformtoSize:(CGSize)newsize;

/**
 将图片转换成和屏幕等倍数比例的图片(如:把下载的图片转成和机型屏幕一样的2倍或者3倍图片)
 
 @param image 需要转换的图片
 @return 转换好的图片
 */
+ (UIImage *)configureTheRatioOfImagesToScreens:(UIImage *)image;

/**
 压缩至接近最大大小
 
 @param maxLength 最大
 @return 图片Data
 */
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
