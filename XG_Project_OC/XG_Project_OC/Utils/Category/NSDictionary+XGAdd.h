//
//  NSDictionary+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (XGAdd)

/// 安全取值的方法(异常时,返回@"")
/// @param key 字典的key
- (id)safeValue:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
