//
//  MJFoundation.m
//  MJExtensionExample
//
//  Created by MJ Lee on 14/7/16.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "TD_MJFoundation.h"
#import "TD_MJConst.h"

static NSArray *_foundationClasses;

@implementation TD_MJFoundation

+ (void)initialize
{
    _foundationClasses = @[@"NSObject", @"NSNumber",@"NSArray", @"NSURL", @"NSMutableURL",@"NSMutableArray",@"NSData",@"NSMutableData",@"NSDate",@"NSDictionary",@"NSMutableDictionary",@"NSString",@"NSMutableString"];
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    MJAssertParamNotNil2(c, NO);
    return [_foundationClasses containsObject:NSStringFromClass(c)];
}
@end
