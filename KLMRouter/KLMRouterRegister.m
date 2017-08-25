//
//  KLMRouterRegister.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/3/31.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMRouterRegister.h"

@interface KLMRouterRegister()

@property(nonatomic, strong) NSMutableArray *paths;
@property(nonatomic, strong) NSMutableArray *interceptors;
@property(nonatomic, strong) NSRegularExpression *regular;

@end

@implementation KLMRouterRegister

static NSString *pattern = @":([a-zA-Z0-9]+)";

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
        _paths = [[NSMutableArray alloc] init];
        _interceptors = [[NSMutableArray alloc] init];
        _regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    }
    return self;
}

- (void)registerWithPath:(NSString *)path toClass:(__unsafe_unretained Class)KLMClass {
    NSAssert(path != nil, @"path can not nil!");
    NSAssert(KLMClass != nil, @"viewController can not nil");
    NSArray *results = [_regular matchesInString:path options:0 range:NSMakeRange(0, path.length)];
    KLMRegistedInfo *info = [KLMRegistedInfo new];
    info.KLMClass = KLMClass;
    if (results.count == 0) {
        info.path = path;
    } else {
        NSString *patternPath = @"";
        NSInteger loc = 0;
        NSMutableArray *parameters = [NSMutableArray new];
        for (NSTextCheckingResult *result in results) {
            patternPath = [patternPath stringByAppendingString:[path substringWithRange:NSMakeRange(loc, result.range.location - loc)]];
            patternPath = [patternPath stringByAppendingString:[pattern substringFromIndex:1]];
            loc = result.range.location + result.range.length;
            [parameters addObject:[NSMutableDictionary dictionaryWithDictionary:@{[path substringWithRange:NSMakeRange(result.range.location+1, result.range.length -1)] : @""}]];
        }
        patternPath = [patternPath stringByAppendingString:[path substringWithRange:NSMakeRange(loc, path.length - loc)]];
        info.path = patternPath;
        info.parameter = parameters;
    }
    [self.paths addObject:info];
}

- (KLMRegistedInfo *)getRegistedInfoWithPath:(NSString *)path {
    KLMRegistedInfo *registedInfo = nil;
    for (KLMRegistedInfo *info in self.paths) {
        NSRegularExpression *pathRegular = [[NSRegularExpression alloc] initWithPattern:info.path options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *results = [pathRegular matchesInString:path options:0 range:NSMakeRange(0, path.length)];
        if (results.count > 0) {
            if (info.parameter != nil) {
                for (NSTextCheckingResult *result in results) {
                    for (NSInteger i = 1; i < result.numberOfRanges; i++) {
                        NSMutableDictionary *p = info.parameter[i-1];
                        [p setObject:[path substringWithRange:[result rangeAtIndex:i]] forKey:p.allKeys[0]];
                    }
                }
            }
            registedInfo = info;
        }
    }
    NSString *msg = [NSString stringWithFormat:@"path:(%@) is not registered", path];
    NSAssert(registedInfo != nil, msg);
    return registedInfo;
}

- (void)addInterceptor:(id<KLMInterceptor>)object {
    [_interceptors addObject:object];
}

- (NSArray *)getInterceptors {
    return self.interceptors;
}

@end
