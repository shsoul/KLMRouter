//
//  KLMInjection.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/4/10.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMInjection.h"

@implementation KLMInjection

+ (void)injectObject:(id)object withParameter:(NSDictionary *)parameter {
    [parameter.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = [parameter objectForKey:obj];
        
            @try {
                [object setValue:value forKey:obj];
            }
            @catch (NSException *exception) {
                NSLog(@"exception:%@",exception);
            }
            @finally {
                
            }
        }];
}

@end
