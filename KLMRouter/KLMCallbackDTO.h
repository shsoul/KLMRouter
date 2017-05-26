//
//  KLMCallbackDTO.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/4/11.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLMCallbackDTO : NSObject

@property(nonatomic, assign) BOOL isSuccess;
@property(nonatomic, strong) NSDictionary *parameter;

@end
