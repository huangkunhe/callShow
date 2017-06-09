//
//  AppDelegate.m
//  callShow
//
//  Created by river on 2017/2/8.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "AppDelegate.h"
#import "HKHNavigationController.h"
#import "ViewController.h"
#import "BlackListViewController.h"


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IMSdk initWithAccountID:INMOBI_INITIALIZE];
    [IMSdk setLogLevel:kIMSDKLogLevelDebug];
    ViewController *homePageVC = [[ViewController alloc] init];
    HKHNavigationController *navVC = [[HKHNavigationController alloc] initWithRootViewController:homePageVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler{
    
    if ([shortcutItem.type isEqualToString:@"BlackListViewController"]) {
        UIViewController *VC = self.window.rootViewController.childViewControllers[0];
        
        BlackListViewController * blackVC = [[BlackListViewController alloc]init];//进入窗口的初始化
        blackVC.backButton =YES;
        [VC.navigationController pushViewController:blackVC animated:YES ];
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //如果陌电识别库Reload曾失败，重新Reload
    if (kReloadMarkInfoError) {
        [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:tkCallMarkKey completionHandler:^(NSError * _Nullable error) {
            if (error) {
                DLog(@"relaodCallBlockInfo error:%@", error.description);
                [UserDefaults setObject:@(YES) forKey:kReloadMarkInfoErrorKey];
                [UserDefaults synchronize];
            } else {
                [UserDefaults setObject:@(NO) forKey:kReloadMarkInfoErrorKey];
                [UserDefaults synchronize];
            }
        }];
    }
    
    if (!kReloadBlockInfoError) {
        [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:tkBlackListKey completionHandler:^(NSError * _Nullable error) {
            if (error) {
                DLog(@"relaodCallBlockInfo error:%@", error.description);
                [UserDefaults setObject:@(YES) forKey:kReloadBlockInfoErrorKey];
                [UserDefaults synchronize];
            } else {
                [UserDefaults setObject:@(NO) forKey:kReloadBlockInfoErrorKey];
                [UserDefaults synchronize];
            }
        }];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
