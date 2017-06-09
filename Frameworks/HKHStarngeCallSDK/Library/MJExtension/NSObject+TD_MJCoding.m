//
//  NSObject+MJCoding.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSObject+TD_MJCoding.h"
#import "NSObject+TD_MJMember.h"

@implementation NSObject (TD_MJCoding)
/**
 *  编码（将对象写入文件中）
 */
- (void)encode:(NSCoder *)encoder
{
    [self enumerateIvarsWithBlock:^(TD_MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        [encoder encodeObject:ivar.value forKey:ivar.name];
    }];
}

/**
 *  解码（从文件中解析对象）
 */
- (void)decode:(NSCoder *)decoder
{
    [self enumerateIvarsWithBlock:^(TD_MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        ivar.value = [decoder decodeObjectForKey:ivar.name];
    }];
}
@end
