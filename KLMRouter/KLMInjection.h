//
//  KLMInjection.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/4/10.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLMInjection : NSObject

+ (void)injectObject:(id)object withParameter:(NSDictionary *)parameter;

@end
