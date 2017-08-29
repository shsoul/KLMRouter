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
@property(nonatomic, strong) NSMutableDictionary *vcMap;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSMutableDictionary *parameter;
@property(nonatomic, assign) BOOL animated;
@property(nonatomic, assign) BOOL isNavigation;
@property(nonatomic, assign) BOOL isRoot;
@property(nonatomic, strong) NSArray *controllers;
@property(nonatomic, strong) KLMCallbackBlock callback;
@property(nonatomic, strong) UIWindow *window;

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
        [_vcMap setObject:newVC forKey:url];
    } else {
        [_vcMap setObject:newVC forKey:url];
    }
    return newVC;
}

- (void)removeViewController:(UIViewController *)vc url:(NSString *)url {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray: vc.navigationController.viewControllers];
    [vcs removeObject:vc];
    vc.navigationController.viewControllers = vcs;
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
                    [self removeViewController:vc url:url];
                    
                    UIViewController *topVC = [self topViewControllerFrom:self.window.rootViewController];
                    
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
                UIViewController *topVC = [self topViewControllerFrom:self.window.rootViewController];
                
                NSAssert(topVC.navigationController != nil, @"current viewController can not push!");
                UIViewController *newVC = [self getNewViewControllerWithClass:info.KLMClass url:url parameter:parameter callback:callback controllers:controllers];
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
            UIViewController *topVC = [self topViewControllerFrom:self.window.rootViewController];
            UIViewController *newVC = [self getNewViewControllerWithClass:info.KLMClass url:url parameter:parameter callback:callback controllers:controllers];
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

- (UIViewController *)topViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerFrom:[(UITabBarController *)vc selectedViewController]];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerFrom:[(UINavigationController *)vc visibleViewController]];
    } else if (vc.presentedViewController) {
        return [self topViewControllerFrom:vc.presentedViewController];
    } else {
        return vc;
    }
}

- (void)popToViewController:(UIViewController *)vc withAnimated:(BOOL)animated {
    UIViewController *topVC = [self topViewControllerFrom:self.window.rootViewController];
    BOOL shouldAnimated = YES;
    while (topVC != vc) {
        if (topVC.tabBarController) {
            UITabBarController *tab = topVC.tabBarController;
            for (UIViewController *tabVC in tab.viewControllers) {
                if (tabVC == vc) {
                    [tab setSelectedViewController:tabVC];
                    topVC = tabVC;
                    return;
                }
            }
        } else if ([topVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topVC;
            for (UIViewController *tabVC in tab.viewControllers) {
                if (tabVC == vc) {
                    [tab setSelectedViewController:tabVC];
                    topVC = tabVC;
                    return;
                }
            }
        } else if (topVC.navigationController && topVC.navigationController.viewControllers.count > 1) {
    
            UIViewController *target = vc.tabBarController ? vc.tabBarController : vc;
            topVC = [self popNavigationControllerStack:topVC target:target animated:shouldAnimated ? animated : NO];
            if (topVC == target) {
                shouldAnimated = NO;
            }
        } else if (topVC.presentingViewController) {
            UIViewController *nextVC = topVC.presentingViewController;
            [self removeMapControllersWithViewController:topVC];
            if (shouldAnimated) {
                [topVC dismissViewControllerAnimated:animated completion:nil];
                shouldAnimated = NO;
            } else {
                [topVC dismissViewControllerAnimated:NO completion:nil];
            }
            topVC = nextVC;
        } else if ([topVC isKindOfClass:[UINavigationController class]]){
            topVC = [(UINavigationController *)topVC topViewController];
        } else {
            return;
        }
    }
}

- (UIViewController *)popNavigationControllerStack:(UIViewController *)topVC target:(UIViewController *)target animated:(BOOL)animated {
    BOOL contains = NO;
    for (UIViewController *subVC in [topVC.navigationController.viewControllers reverseObjectEnumerator]) {
        if (subVC != target) {
            [self removeMapControllersWithViewController:subVC];
        } else {
            contains = YES;
            break;
        }
    }
    if (contains) {
        [topVC.navigationController popToViewController:target animated:animated];
        return target;
    } else {
        UIViewController *nextVC = topVC.navigationController.viewControllers[0];
        [topVC.navigationController popToRootViewControllerAnimated:NO];
        return nextVC;
    }
}
- (void)openRootViewController {
    if ([self.delegate respondsToSelector:@selector(rootWindowFromApp)]) {
        self.window = [self.delegate rootWindowFromApp];
    }
    NSAssert(self.window != nil, @"app window does not exist！please complete KLMRouter delegate.");
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
    if (self.isNavigation) {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    } else {
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];
}

- (void)removeMapControllersWithViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        for (UIViewController *c in [(UITabBarController *)vc viewControllers]) {
            [self removeVC:c];
        }
    }
    [self removeVC:vc];
}

- (void)removeVC:(UIViewController *)vc {
    for (NSString *key in self.vcMap.allKeys) {
        if (self.vcMap[key] == vc) {
            [self.vcMap removeObjectForKey:key];
            break;
        }
    }
}

- (void)popTopViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *vc = [self topViewControllerFrom:self.window.rootViewController];
    [self removeMapControllersWithViewController:vc];
    if (vc.navigationController && vc.navigationController.viewControllers.count > 1) {
        [vc.navigationController popViewControllerAnimated:animated];
        if (completion) {
            completion();
        }
    } else if (vc.presentingViewController) {
        [vc dismissViewControllerAnimated:animated completion:completion];
    }
}

- (void)inject:(id)object withParameter:(NSDictionary *)parameter {
    [KLMInjection injectObject:object withParameter:parameter];
}

@end
