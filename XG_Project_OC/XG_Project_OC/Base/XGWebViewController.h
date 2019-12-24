//
//  XGWebViewController.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/21.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGBaseViewController.h"

#import <WebKit/WebKit.h>
typedef NS_ENUM(NSInteger, XGH5Style) {
    /// H5全屏展示
    XGH5StyleFullScreen,
    /// 使用iOS原生返回按钮和标题
    XGH5StyleiOSBack
};/// 网页navgation类型

NS_ASSUME_NONNULL_BEGIN

@interface XGWebViewController : XGBaseViewController

///点击返回按钮时,是否直接返回app页(默认是先返回H5的上一页,最后返回app的页面)
@property (nonatomic, assign) BOOL isBackToAppPage;

///需要刷新的回调
@property (nonatomic,   copy) void(^needReloadBlock)(void);

///是否使用原生分享按钮
@property (nonatomic, assign) BOOL showShareButton;

///分享标题
@property (nonatomic,   copy) NSString *shareTitle;

///分享内容
@property (nonatomic,   copy) NSString *shareContent;

///分享logo
@property (nonatomic,   copy) NSString *shareLogoUrl;

///分享链接URL
@property (nonatomic,   copy) NSString *shareUrl;

/// 加载网页
/// @param style 网页navgation类型
/// @param vcTitle web的标题
/// @param webUrl url
- (instancetype)initWithH5Style:(XGH5Style)style
                        vcTitle:(NSString *_Nullable)vcTitle
                         webUrl:(NSString *)webUrl;

/// 加载网页
/// @param style 网页navgation类型
/// @param vcTitle web的标题
/// @param webUrl url
/// @param isNeedBackToRootVc 是否需要返回根控制器
- (instancetype)initWithH5Style:(XGH5Style)style
                        vcTitle:(NSString *_Nullable)vcTitle
                         webUrl:(NSString *)webUrl
             isNeedBackToRootVc:(BOOL)isNeedBackToRootVc;

/// 加载本地html
/// @param vcTitle 控制器的标题
/// @param htmlName html的名称
- (instancetype)initWithVcTitle:(NSString *)vcTitle htmlName:(NSString *)htmlName;

@end

NS_ASSUME_NONNULL_END
