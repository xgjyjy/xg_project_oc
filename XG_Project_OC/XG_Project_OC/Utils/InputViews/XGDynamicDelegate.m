//
//  XGDynamicDelegate.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGDynamicDelegate.h"
#import <objc/message.h>

@interface XGDynamicDelegate ()

@property (nonatomic, assign) BOOL isWillBeForwardingLoop;

@end

@implementation XGDynamicDelegate

- (instancetype)initWithKey:(const char *)key {
    _key = key;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (class_respondsToSelector(object_getClass(self.realDelegate), invocation.selector)) {
        [invocation invokeWithTarget:self.realDelegate];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    // Notice: keyboardInputChangedSelection:
    if ([self.realDelegate methodSignatureForSelector:sel]) {
        return [self.realDelegate methodSignatureForSelector:sel];
    }
    return [[NSObject class] methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)selector {
    BOOL respondsSelf = class_respondsToSelector(object_getClass(self), selector);
    /** 当 realDelegate 为 UITextField 时，能够响应 keyboardInputChangedSelection: 方法，此时返回 return YES，但实际上 TXDynamicDelegate 无法响应 keyboardInputChangedSelection:，因此会进入消息转发阶段！(注意：当 realDelegate.delegate = TXDynamicDelegate，则将进入消息无限转发) */
    BOOL respondsReal = class_respondsToSelector(object_getClass(self.realDelegate), selector);
    return respondsSelf || (respondsReal && !_isWillBeForwardingLoop);
}

- (void)sendMsgToObject:(id)obj with:(id)component SEL:(SEL)selector {
    if ([obj respondsToSelector:selector]) {
        void (*funcEntrance)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
        funcEntrance(obj, selector, component);
    }
}

@end

@implementation NSObject (XGOperationDelegate)

static void const * kXGOperationDelegateKey = &kXGOperationDelegateKey;
static void const * kXGDynamicDelegateInfosKey = &kXGDynamicDelegateInfosKey;

/**
 Just NSPointerFunctions sizeFunction.
 @return the size of TXDynamicDelegateInfos size
 */
static NSUInteger getDynamicDelegateInfosSizeFunction(const void *item) {
    return sizeof(XGDynamicDelegateInfos);
}

/**
 返回代理类名
 
 @param cls 被代理的类
 @param suffix 后缀，一般为 delegate
 @return 返回代理类名
 */
static Class hb_getDynamicDelegateClass(Class cls, NSString *suffix) {
    while (cls) {
        NSString *className = [NSString stringWithFormat:@"HBDynamic%@%@", NSStringFromClass(cls), suffix];
        Class ddClass = NSClassFromString(className);
        if (ddClass) return ddClass;
        
        cls = class_getSuperclass(cls);
    }
    
    return [XGDynamicDelegate class];
}

/**
 创建一个串行队列
 */
static dispatch_queue_t hb_getBackgroundQueue(void) {
    static dispatch_once_t onceToken;
    static dispatch_queue_t backgroundQueue = nil;
    dispatch_once(&onceToken, ^{
        backgroundQueue = dispatch_queue_create("huoban.DynamicDelegate.Queue", DISPATCH_QUEUE_SERIAL);
    });
    return backgroundQueue;
}

/**
 返回选择子
 @notes 取自 BlocksKit
 */
static inline SEL getSelectorWithPattern(const char *prefix, const char *key, const char *suffix) {
    size_t prefixLength = prefix ? strlen(prefix) : 0;
    size_t suffixLength = suffix ? strlen(suffix) : 0;
    
    char initial = key[0];
    if (prefixLength) initial = (char)toupper(initial);
    size_t initialLength = 1;
    
    const char *rest = key + initialLength;
    size_t restLength = strlen(rest);
    
    char selector[prefixLength + initialLength + restLength + suffixLength + 1];
    memcpy(selector, prefix, prefixLength);
    selector[prefixLength] = initial;
    memcpy(selector + prefixLength + initialLength, rest, restLength);
    memcpy(selector + prefixLength + initialLength + restLength, suffix, suffixLength);
    selector[prefixLength + initialLength + restLength + suffixLength] = '\0';
    
    return sel_registerName(selector);
}

static inline XGDynamicDelegate *getDynamicDelegate(NSObject *delegatingObject, const XGDynamicDelegateInfos *info, const char *key) {
    
    XGDynamicDelegate *dynamicDelegate = [delegatingObject getDynamicDelegateWithCls:hb_getDynamicDelegateClass(delegatingObject.class, @"Delegate") key:key];
    
    id (*getterFunc)(id, SEL) = (id (*)(id, SEL)) objc_msgSend;
    id getterDelegate = getterFunc(delegatingObject, info->getter);
    
    if ([getterDelegate isKindOfClass:[XGDynamicDelegate class]]) { return dynamicDelegate; }
    
    void (*setterFunc)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
    SEL setterSel = info->hb_setter ?: info->setter;
    setterFunc(delegatingObject, setterSel, dynamicDelegate);
    
    return dynamicDelegate;
}

static bool swizzleMethods(Class cls, SEL oldSel, SEL neSel, IMP neIMP, char const *types) {
    /**
     如果 oldSel 不存在，为当前 TX 类添加 oldSel 方法
     获取 oldSel 的 IMP，如果当前类没有，则获取父类
     */
    IMP oldIMP = class_getMethodImplementation(cls, oldSel);
    
    if (!oldIMP)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Attempt to catch unimplement selector:%@", NSStringFromSelector(oldSel)] userInfo:nil];
    
    class_addMethod(cls, oldSel, oldIMP, types);
    Method oldMethod = class_getInstanceMethod(cls, oldSel);
    if (!oldMethod) return NO;
    
    class_addMethod(cls, neSel, neIMP, types);
    Method neMethod = class_getInstanceMethod(cls, neSel);
    if (!neMethod) return NO;
    
    method_exchangeImplementations(oldMethod, neMethod);
    return YES;
}

- (XGDynamicDelegate *)getDynamicDelegateWithCls:(Class)cls key:(const char *)key {
    
    __block XGDynamicDelegate *dynamicDelegate;
    dispatch_sync(hb_getBackgroundQueue(), ^{
        dynamicDelegate = objc_getAssociatedObject(self, key);
        
        if (!dynamicDelegate)
        {
            dynamicDelegate = [[cls alloc] initWithKey:key];
            objc_setAssociatedObject(self, key, dynamicDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    });
    
    return dynamicDelegate;
}

+ (void)xg_registerDynamicDelegate {
    [self xg_registerDynamicDelegateWithName:@"delegate"];
}

+ (void)xg_registerDynamicDelegateWithName:(NSString *)delegateName {
    if (!delegateName.length) return;
    
    NSMapTable *delegateInfos = [self xg_getDynamicDelegateInfo];
    
    XGDynamicDelegateInfos *dynamicDelegateInfos = (__bridge void *)([delegateInfos objectForKey:(__bridge id _Nullable)kXGDynamicDelegateInfosKey]);
    
    if (!delegateInfos || dynamicDelegateInfos) return;
    
    const char *name = delegateName.UTF8String;
    SEL setter = getSelectorWithPattern("set", name, ":");
    SEL hb_setter = getSelectorWithPattern("xg", sel_getName(setter), NULL);
    SEL getter = NSSelectorFromString(delegateName);
    
    XGDynamicDelegateInfos info = {
        setter, hb_setter, getter
    };
    
    [delegateInfos setObject:(__bridge id)&info forKey:(__bridge id _Nullable)kXGDynamicDelegateInfosKey];
    
    dynamicDelegateInfos = (__bridge void *)[delegateInfos objectForKey:(__bridge id _Nullable)kXGDynamicDelegateInfosKey];
    
    IMP setterImp = imp_implementationWithBlock(^(NSObject *delegatingObject, id delegate) {
        
        XGDynamicDelegate *dynamicDelegate = getDynamicDelegate(delegatingObject, dynamicDelegateInfos, kXGOperationDelegateKey);
        
        if (delegatingObject == delegate) {
            // 标记存在无限转发可能
            dynamicDelegate.isWillBeForwardingLoop = YES;
        }
        dynamicDelegate.realDelegate = delegate;
    });
    
    if (!swizzleMethods(self.class, setter, hb_setter, setterImp, "v@:@")) {
        memset(dynamicDelegateInfos, 0, sizeof(info));// 清空字节
        return;
    }
}

+ (NSMapTable *)xg_getDynamicDelegateInfo {
    NSMapTable *delegateInfos = objc_getAssociatedObject(self, _cmd);
    if (delegateInfos) { return delegateInfos; }
    
    NSPointerFunctions *protocols = [NSPointerFunctions pointerFunctionsWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsObjectPointerPersonality];
    NSPointerFunctions *infoStruct = [NSPointerFunctions pointerFunctionsWithOptions:NSPointerFunctionsMallocMemory|NSPointerFunctionsStructPersonality|NSPointerFunctionsCopyIn];
    infoStruct.sizeFunction = getDynamicDelegateInfosSizeFunction;
    
    delegateInfos = [[NSMapTable alloc] initWithKeyPointerFunctions:protocols valuePointerFunctions:infoStruct capacity:0];
    objc_setAssociatedObject(self, _cmd, delegateInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return delegateInfos;
}

@end
