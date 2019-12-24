//
//  XGSystemEventManager.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/21.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///拨打电话的回调
typedef void(^cellPhoneCompletionHandler)(BOOL success);

@interface XGSystemEventManager : NSObject

/// 拨打电话的操作
/// @param telephone 电话号码
/// @param completionHandler 打电话的回调
+ (void)callTelephone:(NSString *)telephone completionHandler:(nullable cellPhoneCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
