//
//  NSObject+XGObject.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "NSObject+XGAdd.h"
#import <YYKit/NSObject+YYModel.h>
#import <objc/runtime.h>

@implementation NSObject (XGAdd)

- (BOOL)xg_isString {
    if (![self isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString *string = (NSString *)self;
    return string.length > 0;
}

- (BOOL)xg_isNonnull {
    return ![self isKindOfClass:[NSNull class]];
}

- (BOOL)xg_isDictionary {
    return [self isKindOfClass:[NSDictionary class]];
}

- (BOOL)xg_isArray {
    return [self isKindOfClass:[NSArray class]];
}

+ (instancetype)xg_modelWithJSON:(id)json {
    if ([json xg_isNonnull]) {
        return [self modelWithJSON:json];
    } else {
        return nil;
    }
}

+ (NSArray *)xg_modelArrayWithJSON:(id)json {
    if ([json xg_isNonnull]) {
        return [NSArray modelArrayWithClass:self.class json:json];
    } else {
        return nil;
    }
}

- (NSString *)xg_JSONString {
    return [self modelToJSONString];
}

- (BOOL)xg_hasExistPropertyForName:(NSString *)name {
    for (NSString *propertyName in self.class.xg_allProperty) {
        if ([propertyName isEqualToString:name]) return YES;
    }
    return NO;
}

+ (NSArray<NSString *> *)xg_allProperty {
    NSMutableArray *arr = [NSMutableArray array];
    unsigned int count;
    objc_property_t *aPropertyList = class_copyPropertyList(self.class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = aPropertyList[i];
        NSString *aPropertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [arr addObject:aPropertyName];
    }
    free(aPropertyList);
    return [NSArray arrayWithArray:arr];
}

+ (NSArray <NSString *> *)xg_allMethod {
    NSMutableArray *arr = [NSMutableArray array];
    unsigned int count;
    Method *meths = class_copyMethodList(self.class, &count);
    for(int i = 0; i < count; i++) {
        Method meth = meths[i];
        SEL sel = method_getName(meth);
        NSString *aMethodName = [[NSString alloc] initWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding];
        [arr addObject:aMethodName];
    }
    free(meths);
    return [NSArray arrayWithArray:arr];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)xg_currentVc {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

/** dismss到指定vc */
+ (void)dismissToViewController:(UIViewController *)viewController {
    UIViewController *presentingViewController = [self xg_currentVc];
    do {
        if ([presentingViewController isKindOfClass:[viewController class]]) {
            break;
        }
        presentingViewController = presentingViewController.presentingViewController;
        
    } while (presentingViewController.presentingViewController);
    
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
