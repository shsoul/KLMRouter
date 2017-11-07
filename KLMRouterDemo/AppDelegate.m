//
//  AppDelegate.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/5/23.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "AppDelegate.h"
#import "KLMRouter.h"
#import "KLMRouterRegister.h"
#import "KLMHomeViewController.h"
#import "KLMMainViewController.h"
#import "KLMMyViewController.h"
#import "KLMLoginViewController.h"
#import "KLMDetailViewController.h"
#import "KLMLoginInterceptor.h"

@interface AppDelegate ()<KLMRouterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerAll];
    KLMRouter.router.delegate = self;
    KLMRouter.router.buildRoot(@"home").withControllersUrls(@[@"main", @"my"]).withNavigation([UINavigationController class]).navigate();
    return YES;
}

- (void)registerAll {
    [KLMRouterRegister.routerRegister registerWithPath:@"main" toClass:[KLMMainViewController class]];
    [KLMRouterRegister.routerRegister registerWithPath:@"home" toClass:[KLMHomeViewController class]];
    [KLMRouterRegister.routerRegister registerWithPath:@"my" toClass:[KLMMyViewController class]];
    [KLMRouterRegister.routerRegister registerWithPath:@"login" toClass:[KLMLoginViewController class]];
    [KLMRouterRegister.routerRegister registerWithPath:@"detail" toClass:[KLMDetailViewController class]];
    [KLMRouterRegister.routerRegister registerWithPath:@"detail/:goodsId/" toClass:[KLMDetailViewController class]];
    [KLMRouterRegister.routerRegister addInterceptor:[KLMLoginInterceptor new]];
}

- (UIWindow *)rootWindowFromApp {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    return self.window;
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
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
