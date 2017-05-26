//
//  KLMProvider.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/4/5.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLMRouter.h"

@protocol KLMProvider <NSObject>

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback;

@optional
- (void)updateWithParameter:(NSDictionary *)parameter;

@end
