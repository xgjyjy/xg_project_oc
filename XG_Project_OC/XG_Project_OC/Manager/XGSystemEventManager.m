//
//  XGSystemEventManager.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/21.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGSystemEventManager.h"

@implementation XGSystemEventManager

+ (void)callTelephone:(NSString *)telephone completionHandler:(nullable cellPhoneCompletionHandler)completionHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", telephone]];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        // 有可能是iPad, iPod touch
        return;
    }
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO}
                                 completionHandler:^(BOOL success){
                                     completionHandler ? completionHandler(success) : nil;
                                 }];
    } else {
        [[UIApplication sharedApplication] openURL:url];
        completionHandler ? completionHandler(YES) : nil;/** 无法确定,所以只能算成功了 */
    }
}

@end
