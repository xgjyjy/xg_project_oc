//
//  NSURL+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (XGAdd)

/// 低清晰度图片, 暂时使用已有的hd样式
- (NSURL *)thumbImageURL;

@end

NS_ASSUME_NONNULL_END
