//
//  KLMLoginInterceptor.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/4/5.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMLoginInterceptor.h"
#import "KLMRouter.h"

@implementation KLMLoginInterceptor

- (void)processWithPostcard:(KLMPostcard *)postcard callback:(KLMInterceptorBlock)callback {
    if ([postcard.url isEqualToString:@"my"]) {
        KLMRouter.router.build(@"login").withAnimated(YES).withCallback(^(id data) {
            callback([data boolValue]);
        }).present();
    } else {
        callback(YES);
    }
}

@end
