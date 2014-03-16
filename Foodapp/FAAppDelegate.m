//
//  FAAppDelegate.m
//  Foodapp
//
//  Created by Larry Cao on 3/1/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FAAppDelegate.h"

#import "FAMainViewController.h"
#import "FASearchViewController.h"

@interface FAAppDelegate() <UITabBarControllerDelegate>

@end

@implementation FAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    // Override point for customization after application launch.
//    UIViewController *viewController1, *viewController2, *viewController3, *viewController4, *viewController5;
//    
//    viewController1 = [[FAMainViewController alloc] init];
//    viewController1.title = @"First tab";
//    
//    viewController2 = [[FASearchViewController alloc] init];
//    viewController2.title = @"Second tab";
//    
//    viewController3 = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
//    viewController3.title = @"Third tab";
//    
//    viewController4 = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
//    viewController4.title = @"Fourth tab";
//    
//    viewController5 = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
//    viewController5.title = @"Fifth tab";
//    
//    
//    
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    
//    
//    tabBarController.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:viewController1],
//                                         [[UINavigationController alloc] initWithRootViewController:viewController2],
//                                         [[UINavigationController alloc] initWithRootViewController:viewController3],
//                                         [[UINavigationController alloc] initWithRootViewController:viewController4],
//                                         [[UINavigationController alloc] initWithRootViewController:viewController5]];
//    
//	tabBarController.delegate = self;
//    
//    //	if ([tabBarController.tabBar respondsToSelector:@selector(setTranslucent:)]) {
//    // tab bar looks ugly without view controller behind when it is translucent
//    //		tabBarController.tabBar.translucent = NO;
//    //	}
//    self.window.rootViewController = tabBarController;
//    
//    [self.window makeKeyAndVisible];
//    
//    
//    return YES;
//    // Override point for customization after application launch.
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
