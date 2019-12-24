//
//  XGDynamicDelegate.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    SEL setter;
    SEL hb_setter;
    SEL getter;
} XGDynamicDelegateInfos;

@interface XGDynamicDelegate : NSProxy {
    const char *_key;
}

@property (nonatomic,   weak) id realDelegate;

- (instancetype)initWithKey:(const char *)key;

/// 给 realDelegate 发送消息
/// @param component 事件产生组件
/// @param selector 方法名
- (void)sendMsgToObject:(id)obj with:(id)component SEL:(SEL)selector;

@end

@interface NSObject (XGOperationDelegate)

+ (void)xg_registerDynamicDelegate;

@end

NS_ASSUME_NONNULL_END
