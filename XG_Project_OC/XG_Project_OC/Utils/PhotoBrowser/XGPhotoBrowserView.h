//
//  XGPhotoBrowserView.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XGPhotoBrowserView;
@protocol XGPhotoBrowserViewDelegate <NSObject>

- (void)xg_photoBrowserView:(XGPhotoBrowserView *)view
            didSelectPhotos:(nullable NSArray <UIImage *> *)photos
                       urls:(nullable NSArray <NSString *> *)urls;

@end

@interface XGPhotoBrowserView : UIView

/// 代理
@property (nonatomic,   weak) id<XGPhotoBrowserViewDelegate> delegate;

/// 父控制器
@property (nonatomic,   weak) UIViewController *superController;

/// 照片浏览器的内边距(默认 top:15  left:15 bottom:15 right:15)
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/// 照片之间的间距(默认2)
@property (nonatomic, assign) CGFloat photoMargin;

/// 可选最大照片数(默认9)
@property (nonatomic, assign) NSInteger maxCount;

/// 最大列数(默认3)
@property (nonatomic, assign) NSInteger columnCount;

/// 当前相册的高度
@property (nonatomic, assign, readonly) CGFloat currentPhotoBrowserHeight;

@end

NS_ASSUME_NONNULL_END
