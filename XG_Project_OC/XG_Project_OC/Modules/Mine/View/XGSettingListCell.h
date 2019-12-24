//
//  XGSettingListCell.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/9.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 清理图片缓存完成的回调
typedef void(^ClearImageCacheComplete)(void);

@interface XGSettingListCell : UITableViewCell

/// cell的title
@property (nonatomic,   copy) NSString *titleText;

/// 箭头
@property (nonatomic,   copy) NSString *arrowTitle;

/// 是否显示缓存label(默认NO隐藏)
@property (nonatomic, assign, getter=isDisplayCacheLabel) BOOL displayCacheLabel;

/// 是否隐藏分割线
@property (nonatomic, assign, getter=isHideLine) BOOL hideLine;

/// 清理图片缓存
/// @param complete 完成的回调
- (void)clearImageCache:(ClearImageCacheComplete)complete;

@end

NS_ASSUME_NONNULL_END
