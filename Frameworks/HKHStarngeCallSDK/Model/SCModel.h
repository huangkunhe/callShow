//
//  SCModel.h
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCModel : NSObject<NSCoding>

/**
 *  通过字典来创建一个模型
 *
 *  @param dict 字典
 *
 *  @return 新建的对象
 */
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

/**
 *  将模型转成字典
 *
 *  @param model 模型
 *
 *  @return 字典
 */
+ (NSDictionary *)dictionaryWithModel:(id)model;

@end
