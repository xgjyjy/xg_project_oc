//
//  NSObject+XGObject.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XGAdd)

/// 检查是否为合法字符串 条件: class = NSString && string.length > 0 注意: setter方法无效
@property (nonatomic, assign, readonly) BOOL xg_isString;

/// 检查是否为非空对象 条件: object != nil && ![self isKindOfClass:NSNull.class]
@property (nonatomic, assign, readonly) BOOL xg_isNonnull;

/// 检查是否是字典
@property (nonatomic, assign, readonly) BOOL xg_isDictionary;

/// 检查是否是数组
@property (nonatomic, assign, readonly) BOOL xg_isArray;

/**
 JSON转模型, 使用YYModel /  MJExtension
 */
+ (instancetype)xg_modelWithJSON:(id)json;

/**
 JSON转模型数组, 使用YYModel /  MJExtension
 */
+ (NSArray *)xg_modelArrayWithJSON:(id)json;

/**
 模型转JSON, 使用YYModel /  MJExtension
 */
- (NSString *)xg_JSONString;

/**
 通过字符串属性 检查该对象是否存在对应的属性
 
 @param name 属性名称(NSString)
 @return YesOrNo
 */
- (BOOL)xg_hasExistPropertyForName:(NSString *)name;

/**
 获取对象所有的属性
 
 @return 属性列表(NSString类型)
 */
+ (NSArray<NSString *> *)xg_allProperty;

/**
 获取对象的所有方法
 
 @return 方法列表(NSString类型)
 */
+ (NSArray<NSString *> *)xg_allMethod;


/**
 获取当前屏幕显示的viewcontroller

 @return vc
 */
+ (UIViewController *)xg_currentVc;

/**
 dismiss到指定vc

 @param viewController 指定vc
 */
+ (void)dismissToViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
