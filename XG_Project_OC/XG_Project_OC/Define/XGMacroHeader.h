//
//  XGMacroHeader.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#ifndef XGMacroHeader_h
#define XGMacroHeader_h

/// 屏幕宽
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

/// 屏幕高
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

/// 顶部状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

/// 顶部导航栏的默认高度
#define kNavigationBarHeight 44.0f

/// 底部标签栏的高度
#define kTabBarHeight ((AppDelegate *)[UIApplication sharedApplication].delegate).tabberViewController.tabBar.frame.size.height

/// 内容的y值
#define kContentY (kNavigationBarHeight + kStatusBarHeight)

/// 内容的高度
#define kContentHeight (kScreenHeight - kContentY)

/// 沙盒路径
#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

/// dev的log输出
#ifdef DEBUG
#define XGString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define XLog(...) printf("%s %d行: %s\n\n",[XGString UTF8String], __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define XLog(...)
#endif

/// weakSelf
#define kWeakSelf(weakSelf) __weak typeof(&*self)weakSelf = self;

#endif /* XGMacroHeader_h */
