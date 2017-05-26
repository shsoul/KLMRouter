//
//  KLMBaseViewController.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/5/24.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLMProvider.h"

@interface KLMBaseViewController : UIViewController<KLMProvider>

- (void)addBackButton;

@end
