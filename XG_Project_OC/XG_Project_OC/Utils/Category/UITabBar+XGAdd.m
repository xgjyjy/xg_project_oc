//
//  UITabBar+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "UITabBar+XGAdd.h"

@implementation UITabBar (XGAdd)

- (void)showBadgeOnItemIndex:(int)index{
    /** 获取tabbar的数量 */
    NSUInteger tabbarNum = 5;
    /** 移除之前的小红点 */
    [self removeBadgeOnItemIndex:index];
    /** 新建小红点 */
    UIImageView *badgeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_tabbar_news"]];
    badgeImageView.tag = 888 + index;
    CGRect tabFrame = self.frame;
    float percentX = (index + 0.55) / tabbarNum;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeImageView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeImageView];
}

/** 隐藏指定tabbar的小红点 */
- (void)hideBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}

/** 按照tag值进行移除 */
- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
