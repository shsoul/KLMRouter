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
@property(nonatomic, strong) UILabel *label;

@end

@implementation KLMMainViewController

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback {
    if (self = [super initWithParameter:parameter callback:callback]) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"icon_tab_main"] tag:1];
    }
    return self;
}

- (void)updateWithParameter:(NSDictionary *)parameter {
    _label.text = [NSString stringWithFormat:@"返回参数： %@", parameter[@"goodsId"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 200) / 2, self.view.frame.size.width, 30)];
    _label.text = [NSString stringWithFormat:@"返回参数： %d", 0];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, (self.view.frame.size.height - 60) / 2, 100, 60)];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 12;
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitle:@"Go" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(id)sender {
    KLMRouter.router.build(@"detail").withString(@"goodsId", @"10000").withAnimated(YES).withNavigation(YES).present();
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
