//
//  NSArray+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (XGAdd)

/// 安全的取值方法(越界时,返回nil)
/// @param index 下标
- (id)safeValue:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
