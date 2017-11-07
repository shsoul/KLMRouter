//
//  KLMDetailViewController.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/5/24.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMDetailViewController.h"

@interface KLMDetailViewController ()

@property(nonatomic, assign)NSInteger goodsId;

@end

@implementation KLMDetailViewController

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback {
    if (self = [super initWithParameter:parameter callback:callback]) {
        [KLMRouter.router inject:self withParameter:parameter];
    }
    return self;
}

- (id)initWithGoodsId:(NSInteger)goodsId {
    if (self = [super init]) {
        self.goodsId = goodsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详情";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 30) / 2, self.view.frame.size.width, 30)];
    label.text = [NSString stringWithFormat:@"当前商品： %ld", self.goodsId];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, (self.view.frame.size.height - 60) / 2 + 60, 60, 30)];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"商品1" forState:UIControlStateNormal];
    [btn1 setTag:1];
    [btn1 addTarget:self action:@selector(clickGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 60) / 2, (self.view.frame.size.height - 60) / 2 + 60, 60, 30)];
    [btn2 setTitle:@"商品2" forState:UIControlStateNormal];
    [btn2 setTag:2];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clickGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, (self.view.frame.size.height - 60) / 2 + 60, 60, 30)];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn3 setTitle:@"商品3" forState:UIControlStateNormal];
    [btn3 setTag:3];
    [btn3 addTarget:self action:@selector(clickGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *backMain = [[UIButton alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 100) / 2, self.view.frame.size.width, 30)];
    [backMain setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backMain setTitle:@"回到首页" forState:UIControlStateNormal];
    [backMain addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backMain];
}

- (void)backButtonOverrideAction:(id)sender {
    if (self.navigationController.viewControllers.count <= 1) {
        [[KLMRouter router] popTopViewControllerAnimated:YES completion:nil];
    }
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    [[KLMRouter router] removeMapControllersWithViewController:vc];
}

- (void)clickGoods:(id)sender {
    if ([sender tag] == 3) {
        [self.navigationController pushViewController:[[KLMDetailViewController alloc] initWithGoodsId:3] animated:YES];
    } else {
        KLMRouter.router.build([NSString stringWithFormat:@"detail/%ld/", [sender tag]]).withAnimated(YES).backIfExist(NO).navigate();
    }
}

- (void)clickBack:(id)sender {
    KLMRouter.router.build(@"main").withNumber(@"goodsId", @(self.goodsId)).withAnimated(YES).navigate();
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
