//
//  XGTabBarViewController.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/4.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGTabBarViewController.h"
#import "XGNavigationController.h"
#import "UIColor+XGAdd.h"

@interface XGTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation XGTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
       self.tabBar.backgroundColor = [UIColor whiteColor];
       [self configTabberControllers];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"首页"]) {
//        [MobClick event:@"ClickHomeTab"];
    } else {
//        [MobClick event:@"ClickMineTab"];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
   
   
    return YES;
}

/** 配置底部tabbar对应的控制器  */
- (void)configTabberControllers {
    XGNavigationController *homepageNav = [self chiledViewControllerWithTabBarTitle:@"首页"
                                              barNormalImage:@"tab_home_normal"
                                            barSelectedImage:@"tab_home_selected"
                                     rootViewControllerClass:[UIViewController class]];
    
    XGNavigationController *messageNav = [self chiledViewControllerWithTabBarTitle:@"消息"
                                             barNormalImage:@"tab_information_normal"
                                           barSelectedImage:@"tab_information_selected"
                                    rootViewControllerClass:[UIViewController class]];
    XGNavigationController *mineNav = [self chiledViewControllerWithTabBarTitle:@"我的"
                                          barNormalImage:@"tab_my_normal"
                                        barSelectedImage:@"tab_my_selected"
                                 rootViewControllerClass:[UIViewController class]];
}

- (XGNavigationController *)chiledViewControllerWithTabBarTitle:(NSString *)title
                                                  barNormalImage:(NSString *)normalImage
                                                barSelectedImage:(NSString *)selectedImage
                                         rootViewControllerClass:(Class)class {
    UIViewController *vc = [[class alloc] init];
    vc.tabBarItem.title = title;
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        NSMutableDictionary <NSAttributedStringKey, id> *selectedAttributes = self.tabBar.standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes.mutableCopy;
        selectedAttributes[NSForegroundColorAttributeName] = [UIColor redColor];
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes.copy;

        NSMutableDictionary <NSAttributedStringKey, id> *normalAttributes = self.tabBar.standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes.mutableCopy;
        normalAttributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"939393"];
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes.copy;
        
        self.tabBar.standardAppearance = tabBarAppearance;
    } else {
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"939393"]} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    }
    vc.tabBarItem.image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    XGNavigationController *navigationController = [[XGNavigationController alloc] initWithRootViewController:vc];
    return navigationController;
}

@end
