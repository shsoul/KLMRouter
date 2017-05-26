//
//  KLMRouter.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/3/31.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLMInterceptor.h"
#import "KLMInjection.h"

@class UIWindow;

@protocol KLMRouterDelegate <NSObject>

@required
- (UIWindow *)rootWindowFromApp;

@end

@interface KLMRouter : NSObject

@property(nonatomic, weak) id<KLMRouterDelegate> delegate;

+ (KLMRouter *)router;

- (KLMRouter *(^)(NSString *url))build;
- (KLMRouter *(^)(NSString *url))buildRoot;
- (void (^)())navigate;
- (void (^)())present;
- (instancetype)operation;

- (KLMRouter *(^)(NSDictionary *dic))withDictionary;
- (KLMRouter *(^)(NSString *key, NSNumber *num))withNumber;
- (KLMRouter *(^)(NSString *key, NSString *string))withString;
- (KLMRouter *(^)(NSString *key, id value))withObject;
- (KLMRouter *(^)(KLMCallbackBlock callback))withCallback;
- (KLMRouter *(^)(BOOL animated))withAnimated;
- (KLMRouter *(^)(BOOL isNavigation))withNavigation;
- (KLMRouter *(^)(NSArray *urls))withControllersUrls;

- (void)popTopViewController;
- (void)inject:(id)object withParameter:(NSDictionary *)parameter;

@end
