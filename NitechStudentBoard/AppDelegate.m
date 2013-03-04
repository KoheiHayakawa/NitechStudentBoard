//
//  AppDelegate.m
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/18.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "BookmarkViewController.h"
#import "SettingViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MasterViewController *viewController1 = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    viewController1.title = @"ホーム";
    viewController1.tabBarItem.image = [UIImage imageNamed:@"tabbar_board.png"];
    
    BookmarkViewController *viewController2 = [[BookmarkViewController alloc] initWithNibName:@"BookmarkViewController" bundle:nil];
    viewController2.title = @"ブックマーク";
    viewController2.tabBarItem.image = [UIImage imageNamed:@"tabbar_bookmark.png"];
    
    SettingViewController *viewController3 = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    viewController3.title = @"設定";
    viewController3.tabBarItem.image = [UIImage imageNamed:@"tabbar_setting.png"];
    
    NSArray *array = [NSArray arrayWithObjects:
                      [[UINavigationController alloc]initWithRootViewController:viewController1],
                      [[UINavigationController alloc]initWithRootViewController:viewController2],
                      [[UINavigationController alloc]initWithRootViewController:viewController3],
                      nil];
    
    tabBarController = [[UITabBarController alloc]init];
    [tabBarController setViewControllers:array];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:@"1" forKey:@"flag"];
    [userData synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.s
    
    if(tabBarController.selectedIndex == 0){
        tabBarController.selectedViewController = [tabBarController.viewControllers objectAtIndex: 2];
        tabBarController.selectedViewController = [tabBarController.viewControllers objectAtIndex: 0];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
