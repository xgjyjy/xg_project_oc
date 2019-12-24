//
//  XGMineListCell.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/9.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGMineListCell : UITableViewCell

/// 是否隐藏箭头
@property (nonatomic, assign) BOOL isHiddenArrow;

/// title
@property (nonatomic,   copy) NSString *titleText;

/// 右边的View, 在箭头之前
@property (nonatomic, strong) UIView *rightView;

@end

NS_ASSUME_NONNULL_END
