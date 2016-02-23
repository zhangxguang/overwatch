//
//  AppDelegate.m
//  overwatch
//
//  Created by 张祥光 on 15/9/12.
//  Copyright (c) 2015年 张祥光. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXGTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //设置窗口的根控制器
    ZXGTabBarController *tabBarVC = [[ZXGTabBarController alloc] init];
    self.window.rootViewController = tabBarVC;
    
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    // 3.文件路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"herodata.plist"];
    // 4.获取数组
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filePath];
    // 5.如果数组为空，即文件不存在，则创建文件
    if (data == nil) {
        data = [NSMutableArray array];
        [data writeToFile:filePath atomically:YES];
    }
    
    //显示窗口
    [self.window makeKeyAndVisible];
    
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
