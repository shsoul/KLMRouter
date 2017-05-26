//
//  KLMRouterRegister.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/3/31.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLMInterceptor.h"

@interface KLMRouterRegister : NSObject

+ (KLMRouterRegister *)routerRegister;
- (void)registerWithPath:(NSString *)path toClass:(Class)KLMClass;
- (Class)getClassWithPath:(NSString *)path;
- (void)addInterceptor:(id<KLMInterceptor>)object;
- (NSArray *)getInterceptors;

@end
