//
//  KLMLoginViewController.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/5/24.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMLoginViewController.h"

@interface KLMLoginViewController ()

@property(nonatomic, strong) KLMCallbackBlock callback;
@property(nonatomic, strong) UIButton *back;
@property(nonatomic, strong) UIButton *login;

@end

@implementation KLMLoginViewController

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback {
    if (self = [super initWithParameter:parameter callback:callback]) {
        self.callback = callback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _login = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, (self.view.frame.size.height - 60) / 2, 100, 60)];
    [self.view addSubview:_login];
    _login.layer.cornerRadius = 12;
    [_login setBackgroundColor:[UIColor redColor]];
    [_login setTitle:@"login" forState:UIControlStateNormal];
    [_login addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    _back = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 60, 30)];
    [self.view addSubview:_back];
    [_back setBackgroundColor:[UIColor whiteColor]];
    [_back setTitle:@"back" forState:UIControlStateNormal];
    [_back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(id)sender {
    [KLMRouter.router popTopViewControllerAnimated:YES completion:^{
        BOOL isSuccess = sender == _back ? NO : YES;
        if (self.callback) {
            self.callback(@(isSuccess));
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"loginPage exit!");
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
