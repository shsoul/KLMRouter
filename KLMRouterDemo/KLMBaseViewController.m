//
//  KLMBaseViewController.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/5/24.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMBaseViewController.h"

@interface KLMBaseViewController ()

@end

@implementation KLMBaseViewController

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)addBackButton {
    //back
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_common_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonOverrideAction:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
}

- (void)backButtonOverrideAction:(id)sender {
    [[KLMRouter router] popTopViewController];
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
