
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "NSObject+TD.h"
#import <objc/runtime.h>

@implementation NSObject (TD)

+ (BOOL)isContainParent
{
    return NO;
}

+ (void)getSelfPropertys:(NSMutableArray *)pronames protypes:(NSMutableArray *)protypes
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [pronames addObject:propertyName];
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        /*
         c char
         i int
         l long
         s short
         d double
         f float
         @ id //指针 对象
         ...  BOOL 获取到的表示 方式是 char
         .... ^i 表示  int*  一般都不会用到
         */
        
        if ([propertyType hasPrefix:@"T@"]) {
            [protypes addObject:[propertyType substringWithRange:NSMakeRange(3, [propertyType rangeOfString:@","].location-4)]];
        }
        else if([propertyType hasPrefix:@"T{"]) {
            [protypes addObject:[propertyType substringWithRange:NSMakeRange(2, [propertyType rangeOfString:@"="].location-2)]];
        }
        else {
            propertyType = [propertyType lowercaseString];
            if ([propertyType hasPrefix:@"ti"]) {
                [protypes addObject:@"int"];
            }
            else if ([propertyType hasPrefix:@"tf"]) {
                [protypes addObject:@"float"];
            }
            else if([propertyType hasPrefix:@"td"]) {
                [protypes addObject:@"double"];
            }
            else if([propertyType hasPrefix:@"tl"]) {
                [protypes addObject:@"long"];
            }
            else if ([propertyType hasPrefix:@"tc"]) {
                [protypes addObject:@"char"];
            }
            else if([propertyType hasPrefix:@"ts"]) {
                [protypes addObject:@"short"];
            }
            else {
                [protypes addObject:@"NSString"];
            }
        }
    }
    free(properties);
    if([self isContainParent] && [self superclass] != [NSObject class])
    {
        [[self superclass] getSelfPropertys:pronames protypes:protypes];
    }
}

@end
