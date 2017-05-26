# KLMRouter
A iOS router that help app navigate to controllers.

### 安装
```
pod 'KLMRouter', '1.0.1'
```

### 支持
* 支持iOS5及以上。
* 页面路由支持push和present两种常用打开方式。
* 支持路由拦截器。
* 支持参数依赖注入。

### 使用
* 实现KLMRouter delegate，让KLMRouter获取UIWindow。

```
@protocol KLMRouterDelegate <NSObject>

@required
- (UIWindow *)rootWindowFromApp;

@end

//一般在APPDelegate里面实现
- (UIWindow *)rootWindowFromApp {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    return self.window;
}

```

* 注册ViewController

```
[KLMRouterRegister.routerRegister registerWithPath:@"main" toClass:[KLMMainViewController class]];
```

* 路由的ViewController需要实现协议

```
@protocol KLMProvider <NSObject>

- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback; //必须实现

@optional
- (void)updateWithParameter:(NSDictionary *)parameter;//可选实现

@end
```

* 初始路由到rootViewController

```
KLMRouter.router.delegate = self;

//初始home是TabBarController，里面有两个Controller，“main”和“my”，包了一层UINavigationController。
KLMRouter.router.buildRoot(@"home").withControllersUrls(@[@"main", @"my"]).withNavigation(YES).navigate();
```

* 普通路由方式

```
//请记住，由KLMRouter进来的，必须用KLMRouter回去。
//如果不是KLMRouter进来的：原生的present打开的可以用KLMRouter回去某个navigate结点，push进来的不能用KLMRouter回去（因此用了KLMRouter，尽量不要用原生push了，没必要。。。）
KLMRouter.router.build(@"detail").withString(@"say", @"hello").withAnimated(YES).navigate();  //push的方式，如果之前已存在，则回去之前存在的，否则打开一个新的。

KLMRouter.router.build(@"login").withAnimated(YES).withCallback(^(KLMCallbackDTO *dto) {
            //callbackblock
        }).present(); //present方式
        
[[KLMRouter router] popTopViewController];//把顶部的ViewController 弹走，包括以push和present方式呈现的。
```

* 依赖注入

```
//需要注意的是：注入的属性名必须和传进的参数的key的名字一致。
- (id)initWithParameter:(NSDictionary *)parameter callback:(KLMCallbackBlock)callback {
    if (self = [super initWithParameter:parameter callback:callback]) {
        [KLMRouter.router inject:self withParameter:parameter];
    }
    return self;
}
```

* 拦截器

	拦截器需要实现协议：KLMInterceptor
	
	```
	@interface KLMLoginInterceptor : NSObject<KLMInterceptor>

	@end
	
	@implementation KLMLoginInterceptor

	- (void)processWithPostcard:(KLMPostcard *)postcard callback:	(KLMInterceptorBlock)callback {
		//需要拦截，todo。。。
    	if ([postcard.url isEqualToString:@"my"]) {
        	KLMRouter.router.build(@"login").withAnimated(YES).withCallback(^(KLMCallbackDTO *dto) {
            callback(dto.isSuccess);
        }).present();
   		} else {
       		callback(YES);
    	}
	}
	@end
	```
	
	注册拦截器
	
	```
	[KLMRouterRegister.routerRegister addInterceptor:[KLMLoginInterceptor new]];
	```
	
### KLMRouter方法说明

| 方法        | 参数           |  说明  |
| :-----------: |:-------------:| :-----:|
| build()          | NSString | 普通路由方式，但是在之前必须先有buildRoot(),传注册过的path  |
| buildRoot()      | NSString      |   跟build()类似，不同的这是设置rootViewController  |
| navigate()       | 无      |    以push方式进行路由，如果某页面已存在，则会路由到那个页面，如果那页面实现updateWithParameter: 协议，则调用这个updateWithParameter方法。如果页面不存在，则新建一个页面。 |
| present()      | 无      |    以present方式路由，无论页面之前是否存在，都会新建页面  |
| withDictionary() | NSDictionary      |    传参，跟withNumber(key,value)等类似  |
| withCallback() | KLMCallbackBlock      |    传参（callback），可以把参数callback回来 |
| withNavigation() | BOOL      |    是否需要包UINavigationController  |
| withControllersUrls() | NSArray，数组内是NSString     |    build(),buildRoot()是UITabBarController才可以  |

#### 注：具体使用请参考[KLMRouterDemo](https://github.com/shsoul/KLMRouter).
