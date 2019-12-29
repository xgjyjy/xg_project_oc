//
//  AppDelegate.m
//  HB_NewProject
//
//  Created by 伙伴行 on 2019/12/3.
//  Copyright © 2019 HB_NewProject. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabBarVc = [[XGTabBarViewController alloc] init];
    self.window.rootViewController = self.tabBarVc;
    [self.window makeKeyAndVisible];
    
     
    NSString *jPushKey = nil;/** 极光推送appKey */
    BOOL isProduction;/** 极光推送的证书环境,0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用 */
    
//    5e080142cb23d294a7000a92 友盟的key
#ifdef DEBUG
    jPushKey = @"5755fff18ed0ea697d3afc76";
    //    NIMAppKey = @"8fc95f505b6cbaedf613677c8e08fc0b";/** 云信demo的appkey */
    isProduction = NO;
    //        [UMCommonLogManager setUpUMCommonLogManager];/** debug下开启友盟日志系统 */
    //        [UMConfigure setLogEnabled:NO];/** debug下开启友盟log功能 */
    //        [MobClick setCrashReportEnabled:NO];/** 开发环境关闭友盟收集crash功能 */
#else
    jPushKey = @"12ae03709ff82fffa1b3ee23";
    isProduction = YES;
#endif
    
    return YES;
}



@end
