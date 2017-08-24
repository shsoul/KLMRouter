//
//  KLMRouter.m
//  KLMRouter
//
//  Created by zhangshuijie on 2017/3/31.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import "KLMRouter.h"
#import "KLMRouterRegister.h"
#import "KLMPostcard.h"
#import "KLMProvider.h"
#import <UIKit/UIKit.h>

@interface KLMRouter()

@property(nonatomic, strong) KLMRouterRegister *routerRegister;
@property(nonatomic, strong) NSMutableArray *pathsStack;
@property(nonatomic, strong) NSMutableDictionary *vcMap;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSMutableDictionary *parameter;
@property(nonatomic, assign) BOOL animated;
@property(nonatomic, assign) BOOL isNavigation;
@property(nonatomic, assign) BOOL isRoot;
@property(nonatomic, strong) NSArray *controllers;
@property(nonatomic, strong) KLMCallbackBlock callback;

@end

@implementation KLMRouter

+ (KLMRouter *)router {
    static KLMRouter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[KLMRouter alloc] init];
        }
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.routerRegister = [KLMRouterRegister routerRegister];
        _pathsStack = [NSMutableArray new];
        _vcMap = [NSMutableDictionary new];
        [self setup];
        
    }
    return self;
}

- (void)setup {
    _parameter = [NSMutableDictionary new];
    _animated = NO;
    _isNavigation = NO;
    _callback = nil;
    _controllers = nil;
    _isRoot = NO;
    _controllers = nil;
}

- (KLMRouter* (^)(NSString *url))build {
    [self setup];
    return ^(NSString *url) {
        self.url = url;
        return self;
    };
}

- (KLMRouter* (^)(NSString *url))buildRoot {
    [self setup];
    self.isRoot = YES;
    _pathsStack = [NSMutableArray new];
    _vcMap = [NSMutableDictionary new];
    return ^(NSString *url) {
        self.url = url;
        return self;
    };
}

-(KLMRouter *(^)(KLMCallbackBlock callback))withCallback {
    return ^(KLMCallbackBlock callback) {
        self.callback = callback;
        return self;
    };
}

- (KLMRouter *(^)(BOOL isNavigation))withNavigation {
    return ^(BOOL isNavigation) {
        self.isNavigation = isNavigation;
        return self;
    };
}

- (KLMRouter *(^)(BOOL animated))withAnimated {
    return ^(BOOL animated) {
        self.animated = animated;
        return self;
    };
}

- (KLMRouter *(^)(NSDictionary *dic))withDictionary {
    return ^(NSDictionary *dic) {
        if (dic) {
            [self.parameter addEntriesFromDictionary:dic];
        }
        return self;
    };
}

- (KLMRouter *(^)(NSString *key, NSNumber *num))withNumber {
    return ^(NSString *key, NSNumber *num) {
        if (key && num) {
            [self.parameter addEntriesFromDictionary:@{key : num}];
        }
        return self;
    };
}

- (KLMRouter *(^)(NSString *key, NSString *string))withString {
    return ^(NSString *key, NSString *string) {
        if (key && string) {
            [self.parameter addEntriesFromDictionary:@{key : string}];
        }
        return self;
    };
}

- (KLMRouter *(^)(NSString *key, id value))withObject {
    return ^(NSString *key, id value) {
        if (key && value) {
            [self.parameter addEntriesFromDictionary:@{key : value}];
        }
        return self;
    };
}

- (KLMRouter *(^)(NSArray *urls))withControllersUrls {
    return ^(NSArray *urls) {
        self.controllers = urls;
        return self;
    };
} 

- (void (^)())navigate {
    if (self.isRoot) {
        [self openRootViewController];
    } else {
        [self pushWithUrl:self.url animated:self.animated parameter:self.parameter callBack:self.callback controllers:self.controllers];
    }
    return ^() {
        
    };
}

- (void (^)())present {
    [self presentWithUrl:self.url animated:self.animated parameter:self.parameter callback:self.callback controllers:self.controllers];
    return ^() {
        
    };;
}

- (instancetype)operation {
    return [[[self.routerRegister getRegistedInfoWithPath:self.url].class alloc] initWithParameter:self.parameter callback:self.callback];
}

- (UIViewController *)getNewViewControllerWithClass:(Class)class url:(NSString *)url parameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback controllers:(NSArray *)controllers {
    UIViewController *newVC = [[class alloc] initWithParameter:parameter callback:callback];
    if (controllers.count) {
        NSMutableArray *vcArray = [[NSMutableArray alloc] init];
        for (NSString *url in controllers) {
            UIViewController *tab = [[[self.routerRegister getRegistedInfoWithPath:url].KLMClass alloc] initWithParameter:nil callback:nil];
            [vcArray addObject:tab];
            [_vcMap setObject:tab forKey:url];
        }
        NSAssert(([newVC isKindOfClass:[UITabBarController class]]), @"not tabBarController");
        [(UITabBarController *)newVC setViewControllers:vcArray animated:NO];
        [_vcMap setObject:@{@"controllers" : controllers,
                            @"tabBarController" : newVC} forKey:url];
    } else {
        [_vcMap setObject:newVC forKey:url];
    }
    return newVC;
}

- (KLMPostcard *)removeViewController:(UIViewController *)vc url:(NSString *)url {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray: vc.navigationController.viewControllers];
    [vcs removeObject:vc];
    vc.navigationController.viewControllers = vcs;
    KLMPostcard *post = nil;
    for (KLMPostcard *postcard in self.pathsStack) {
        if ([postcard.url isEqualToString:url]) {
            post = postcard;
            [self.pathsStack removeObject:postcard];
            break;
        }
    }
    return post;
}

- (void)pushWithUrl:(NSString *)url animated:(BOOL)animated parameter:(NSDictionary *)parameter callBack:(KLMCallbackBlock)callback controllers:(NSArray *)controllers {
    UIViewController *vc = [_vcMap objectForKey:url];
    KLMRegistedInfo *info = [self.routerRegister getRegistedInfoWithPath:url];
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:parameter];
    for (NSMutableDictionary *d in info.parameter) {
        [p addEntriesFromDictionary:d];
    }
    parameter = p;
    KLMPostcard *postcard = [[KLMPostcard alloc] init];
    postcard.url = url;
    postcard.openMode = KLMPush;
    postcard.parameter = parameter;
    [self handleWithInterceptorsWithPostcard:postcard callback:^(BOOL isSuccess) {
        if (isSuccess) {
            if (vc) {
                if (info.parameter) {
                    KLMPostcard *post = [self removeViewController:vc url:url];
                    
                    UIViewController *topVC = [self topViewController];
                    if ([topVC isKindOfClass:[UITabBarController class]]) {
                        topVC = [(UITabBarController *)topVC selectedViewController];
                    }
                    
                    [self.pathsStack addObject:post];
                    
                    NSAssert(topVC.navigationController != nil, @"current viewController can not push!");
                    [topVC.navigationController pushViewController:vc animated:animated];
                    if ([vc respondsToSelector:@selector(updateWithParameter:)]) {
                        [(id<KLMProvider>)vc updateWithParameter:parameter];
                    }
                } else {
                    [self popToViewController:vc withAnimated:animated];
                    if ([vc respondsToSelector:@selector(updateWithParameter:)]) {
                        [(id<KLMProvider>)vc updateWithParameter:parameter];
                    }
                }
            } else {
                UIViewController *topVC = [self topViewController];
                if ([topVC isKindOfClass:[UITabBarController class]]) {
                    topVC = [(UITabBarController *)topVC selectedViewController];
                }
                
                NSAssert(topVC.navigationController != nil, @"current viewController can not push!");
                UIViewController *newVC = [self getNewViewControllerWithClass:info.KLMClass url:url parameter:parameter callback:callback controllers:controllers];
                [self.pathsStack addObject:postcard];
                [topVC.navigationController pushViewController:newVC animated:animated];
            }
        }
    }];
}

- (void)presentWithUrl:(NSString *)url animated:(BOOL)animated parameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback controllers:(NSArray *)controllers {
    KLMRegistedInfo *info = [self.routerRegister getRegistedInfoWithPath:url];
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:parameter];
    for (NSMutableDictionary *d in info.parameter) {
        [p addEntriesFromDictionary:d];
    }
    parameter = p;
    KLMPostcard *postcard = [[KLMPostcard alloc] init];
    postcard.url = url;
    postcard.openMode = KLMPresent;
    postcard.parameter = parameter;
    [self handleWithInterceptorsWithPostcard:postcard callback:^(BOOL isSuccess) {
        if (isSuccess) {
            UIViewController *topVC = [self topViewController];
            if ([topVC isKindOfClass:[UITabBarController class]]) {
                topVC = [(UITabBarController *)topVC selectedViewController];
            }
            UIViewController *newVC = [self getNewViewControllerWithClass:info.KLMClass url:url parameter:parameter callback:callback controllers:controllers];
            [self.pathsStack addObject:postcard];
            if (self.isNavigation) {
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newVC];
                [topVC presentViewController:nav animated:animated completion:nil];
            } else {
                [topVC presentViewController:newVC animated:animated completion:nil];
            }
        }
    }];
    
}

- (void)handleWithInterceptorsWithPostcard:(KLMPostcard *)p callback:(KLMInterceptorBlock)callback {
    __block BOOL isOK = YES;
    __block NSInteger count = 0;
    if (![[KLMRouterRegister routerRegister] getInterceptors].count) {
        callback(isOK);
        return;
    }
    for (id<KLMInterceptor> interceptor in [[KLMRouterRegister routerRegister] getInterceptors]) {
        [interceptor processWithPostcard:p callback:^(BOOL isSuccess) {
            if (!isSuccess) {
                isOK = NO;
            }
            count++;
            if (count == [[KLMRouterRegister routerRegister] getInterceptors].count) {
                callback(isOK);
            }
        }];
    }
}

- (UIViewController *)topViewController {
    KLMPostcard *postcard = [self.pathsStack lastObject];
    id x = [self.vcMap objectForKey:postcard.url];
    if ([x isKindOfClass:[NSDictionary class]]) {
        return x[@"tabBarController"];
    } else {
        return x;
    }
}

- (void)popToViewController:(UIViewController *)vc withAnimated:(BOOL)animated {
    KLMPostcard *postcard = [self.pathsStack lastObject];
    UIViewController *topVC = [self topViewController];
    while (topVC != vc) {
        if ([topVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topVC;
            for (UIViewController *tabVC in tab.viewControllers) {
                if (tabVC == vc) {
                    [tab setSelectedViewController:tabVC];
                    topVC = tabVC;
                    return;
                }
            }
        }
        postcard = [self.pathsStack lastObject];
        [self.pathsStack removeLastObject];
        [self removeMapControllersWithPath:postcard.url];
        UIViewController *nextVC = [self topViewController];
        BOOL shouldAnimated = NO;
        if ((nextVC == vc || ([nextVC isKindOfClass:[UITabBarController class]] && [[(UITabBarController *)nextVC viewControllers] containsObject:vc])) && animated) {
            shouldAnimated = YES;
        }
        [self dismissModalViewController:topVC.presentedViewController];
        if (postcard.openMode == KLMPresent) {
            [topVC dismissViewControllerAnimated:shouldAnimated completion:nil];
        } else {
            [topVC.navigationController popViewControllerAnimated:shouldAnimated];
        }
        topVC = nextVC;
    }
}

- (void)openRootViewController {
    UIWindow *window = nil;
    if ([self.delegate respondsToSelector:@selector(rootWindowFromApp)]) {
        window = [self.delegate rootWindowFromApp];
    }
    NSAssert(window != nil, @"app window does not exist！please complete KLMRouter delegate.");
    KLMRegistedInfo *info = [self.routerRegister getRegistedInfoWithPath:self.url];
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:self.parameter];
    for (NSMutableDictionary *d in info.parameter) {
        [p addEntriesFromDictionary:d];
    }
    KLMPostcard *postcard = [[KLMPostcard alloc] init];
    postcard.url = self.url;
    postcard.openMode = KLMPush;
    postcard.parameter = self.parameter;
    UIViewController *vc = [self getNewViewControllerWithClass:info.KLMClass url:self.url parameter:self.parameter callback:self.callback controllers:self.controllers];
    [self.pathsStack addObject:postcard];
    if (self.isNavigation) {
        window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    } else {
        window.rootViewController = vc;
    }
    [window makeKeyAndVisible];
}

- (void)removeMapControllersWithPath:(NSString *)url {
    id x = [self.vcMap objectForKey:url];
    if ([x isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in x[@"controllers"]) {
            [self.vcMap removeObjectForKey:key];
        }
    }
    [self.vcMap removeObjectForKey:url];
}

- (void)dismissModalViewController:(UIViewController *)vc {
    if (vc == nil) {
        return;
    }
    if (vc.presentedViewController == nil) {
        [vc dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self dismissModalViewController:vc.presentedViewController];
    }
}

- (void)popTopViewController {
    if (self.pathsStack.count <= 1) {
        return;
    }
    KLMPostcard *postcard = [self.pathsStack lastObject];
    UIViewController *vc = [self.vcMap objectForKey:postcard.url];
    [self dismissModalViewController:vc.presentedViewController];
    if (postcard.openMode == KLMPresent) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    } else {
        [vc.navigationController popViewControllerAnimated:YES];
    }
    [self.pathsStack removeLastObject];
    [self removeMapControllersWithPath:postcard.url];
}

- (void)inject:(id)object withParameter:(NSDictionary *)parameter {
    [KLMInjection injectObject:object withParameter:parameter];
}

@end
