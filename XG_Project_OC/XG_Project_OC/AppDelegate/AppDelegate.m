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
    return YES;
}



@end
