//
//  AppDelegate.m
//  自定义标签控制器
//
//  Created by LLQ on 16/4/28.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "AppDelegate.h"
#import "CRIViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    //创建一个可变数组，用来存放视图控制器对象
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    //创建两个数组来存放标题和图片信息
    NSArray *titles = @[@"主页",@"信息",@"购票",@"发现",@"商店"];
    NSArray *imgNames = @[@"home",@"myinfo",@"payticket",@"discover",@"store"];
    
    for (int i=0; i<5; i++) {
        UIViewController *viewController = nil;
        
        UIViewController *vc = [[UIViewController alloc] init];
        //设置视图标签栏标题  标题图片
        vc.title = titles[i];
        vc.tabBarItem.image = [UIImage imageNamed:imgNames[i]];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_on",imgNames[i]]];
        vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
        
        viewController = vc;
//        if (i<2) {
            //前两个视图添加导航控制器
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            viewController = nav;
//        }
        //将创建好的视图控制器添加入数组，以便于添加入标签控制器
        [viewControllers addObject:viewController];
    }
    
    //设置标签控制器
    
    CRIViewController *tabbar = [[CRIViewController alloc] init];
    //选中图片
    tabbar.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"选中"];
    //背景图片
    tabbar.tabBar.backgroundImage = [UIImage imageNamed:@"tab_bg_all"];
    
    //将视图添加入标签控制器
    tabbar.viewControllers = viewControllers;
    
    //将窗口的根视图控制器设置为tabbar
    self.window.rootViewController = tabbar;
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
