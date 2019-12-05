//
//  UIResponder+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "UIResponder+XGAdd.h"

static __weak id xg_currentFirstResponder;

@implementation UIResponder (XGAdd)

+ (id)currentFirstResponder {
    xg_currentFirstResponder = nil;
    // 通过将target设置为nil，让系统自动遍历响应链
    // 从而响应链当前第一响应者响应我们自定义的方法
    [[UIApplication sharedApplication] sendAction:@selector(xg_findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return xg_currentFirstResponder;
}

- (void)xg_findFirstResponder:(id)sender {
    // 第一响应者会响应这个方法，并且将静态变量xg_currentFirstResponder设置为自己
    xg_currentFirstResponder = self;
}

@end
