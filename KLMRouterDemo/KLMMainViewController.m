//
//  KLMMainViewController.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/5/24.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMMainViewController.h"
#import "KLMDetailViewController.h"

@interface KLMMainViewController ()

@end

@implementation KLMMainViewController

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback {
    if (self = [super initWithParameter:parameter callback:callback]) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"icon_tab_main"] tag:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, (self.view.frame.size.height - 60) / 2, 100, 60)];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 12;
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitle:@"say" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(id)sender {
    KLMRouter.router.build(@"detail").withString(@"say", @"hello").withAnimated(YES).navigate();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
