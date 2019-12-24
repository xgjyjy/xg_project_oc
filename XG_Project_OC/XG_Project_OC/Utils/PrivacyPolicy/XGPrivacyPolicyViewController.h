//
//  XGPrivacyPolicyViewController.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGPrivacyPolicyViewController : XGBaseViewController

@property (nonatomic,   copy) void(^agreeBackBlock)(void);

@end

NS_ASSUME_NONNULL_END
