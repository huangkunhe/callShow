//
//  SCModel.m
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "SCModel.h"

@implementation SCModel

#pragma mark - 模型转换
#pragma mark 通过字典来创建一个模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dict
{
    return [self objectWithKeyValues:dict];
}

#pragma mark 将模型转成字典
+ (NSDictionary *)dictionaryWithModel:(id)model
{
    return [model keyValues];
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        @try {
            for (int i = 0; i < outCount; i++)
            {
                objc_property_t property = properties[i];
                NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                id value = [aDecoder decodeObjectForKey:key];
                [self setValue:value forKey:key];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            return nil;
        }
        @finally {
            
        }
        
        free(properties);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:key];
        if (value && key)
        {
            if ([value isKindOfClass:[NSObject class]]) {
                [aCoder encodeObject:value forKey:key];
            }
            else {
                NSNumber *v = [NSNumber numberWithInt:(int)value];
                [aCoder encodeObject:v forKey:key];
            }
        }
    }
    free(properties);
    properties = NULL;
}




@end
