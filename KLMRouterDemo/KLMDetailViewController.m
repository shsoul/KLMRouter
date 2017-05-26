//
//  KLMDetailViewController.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/5/24.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMDetailViewController.h"

@interface KLMDetailViewController ()

@property(nonatomic, strong) NSString *say;

@end

@implementation KLMDetailViewController

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback {
    if (self = [super initWithParameter:parameter callback:callback]) {
        [KLMRouter.router inject:self withParameter:parameter];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详情";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 60) / 2, self.view.frame.size.width, 60)];
    label.text = _say;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
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
