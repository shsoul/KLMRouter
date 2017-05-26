//
//  KLMHomeViewController.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/5/23.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMHomeViewController.h"

@interface KLMHomeViewController ()<UITabBarControllerDelegate>

@end

@implementation KLMHomeViewController

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == [[tabBarController viewControllers] objectAtIndex:0]) {
        KLMRouter.router.build(@"main").navigate();
    } else if (viewController == [[tabBarController viewControllers] objectAtIndex:1]) {
        KLMRouter.router.build(@"my").navigate();
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
