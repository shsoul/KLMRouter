//
//  KLMRouterRegister.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/3/31.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMRouterRegister.h"

@interface KLMRouterRegister()

@property(nonatomic, strong) NSMutableDictionary *paths;
@property(nonatomic, strong) NSMutableArray *interceptors;

@end

@implementation KLMRouterRegister

+ (KLMRouterRegister *)routerRegister {
    static KLMRouterRegister *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[KLMRouterRegister alloc] init];
        }
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _paths = [[NSMutableDictionary alloc] init];
        _interceptors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerWithPath:(NSString *)path toClass:(__unsafe_unretained Class)KLMClass {
    NSAssert(path != nil, @"path can not nil!");
    NSAssert(KLMClass != nil, @"viewController can not nil");
    [_paths setObject:KLMClass forKey:path];
}

- (Class)getClassWithPath:(NSString *)path {
    NSAssert([_paths objectForKey:path] != nil, @"path is not registered");
    return [_paths objectForKey:path];
}

- (void)addInterceptor:(id<KLMInterceptor>)object {
    [_interceptors addObject:object];
}

- (NSArray *)getInterceptors {
    return self.interceptors;
}

@end
