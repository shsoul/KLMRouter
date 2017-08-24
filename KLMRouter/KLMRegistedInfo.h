//
//  KLMRegistedInfo.h
//  KLMRouter
//
//  Created by zhangshuijie on 2017/8/22.
//  Copyright © 2017年 sjst.xgfe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLMRegistedInfo : NSObject

@property(nonatomic, strong)Class KLMClass;
@property(nonatomic, strong)NSArray<NSMutableDictionary *> *parameter;
@property(nonatomic, strong)NSString *path;

@end
