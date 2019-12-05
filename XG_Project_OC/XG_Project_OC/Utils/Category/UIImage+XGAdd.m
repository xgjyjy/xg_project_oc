//
//  UIImage+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "UIImage+XGAdd.h"

@implementation UIImage (XGAdd)

/** 按照指定size裁剪图片 */
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    }
    [self drawInRect:CGRectMake(-1, -1, width+2, height+2)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 按照指定大小和屏幕比列裁剪图片 */
- (UIImage *)transformtoSize:(CGSize)newsize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(newsize, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/** 等比例和指定大小缩放图片 */
- (UIImage*)scaleToSize:(CGSize)size {
    CGSize smallSize = CGSizeMake(size.width, size.height);
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(smallSize, YES, 0);
    }
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(-1, -1, smallSize.width+2, smallSize.height+2)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/** 按照4:3比例裁剪图片 */
- (UIImage *)croppedImage {
    if (self) {
        float W = self.size.width;
        float H = self.size.height;
        CGRect rects;
        if (W < H) {
            rects = CGRectMake(0, (H-1.33*W)/2, W,1.33*W);/** 裁剪成3：4的 */
        }else {
            rects = CGRectMake(0, (H-0.75*W)/2, W,0.75*W);
        }
        CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage,rects);
        CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
        UIGraphicsBeginImageContextWithOptions(smallBounds.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, smallBounds, subImageRef);
        UIImage *viewImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);
        return viewImage;
    }
    return nil;
}

/** 将图片转换成和屏幕等倍数比例的图片(如:把下载的图片转成和机型屏幕一样的2倍或者3倍图片) */
+ (UIImage *)configureTheRatioOfImagesToScreens:(UIImage *)image{
    UIImage *newImage = [UIImage imageWithCGImage:[image CGImage] scale:3 orientation:UIImageOrientationUp];
    newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return newImage;
}

- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

@end
