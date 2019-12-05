//
//  UIResponder+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (XGAdd)

/**
 获取当前第一响应者
 
 @return 第一响应者
 */
+ (id)currentFirstResponder;

@end

NS_ASSUME_NONNULL_END
