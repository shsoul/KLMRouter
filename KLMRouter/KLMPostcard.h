//
//  KLMPostcard.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/4/6.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    KLMPresent,
    KLMPush,
} KLMOpenOperation;

@interface KLMPostcard : NSObject

@property(nonatomic, strong) NSString *url;
@property(nonatomic, assign) KLMOpenOperation openMode;
@property(nonatomic, strong) NSDictionary *parameter;

@end
