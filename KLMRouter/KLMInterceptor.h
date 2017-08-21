//
//  KLMInterceptor.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/4/1.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLMPostcard.h"

typedef void(^KLMInterceptorBlock)(BOOL isSuccess);

typedef void(^KLMCallbackBlock)(id callbackData);

@protocol KLMInterceptor <NSObject>

- (void)processWithPostcard:(KLMPostcard *)postcard callback:(KLMInterceptorBlock)callback;

@end
