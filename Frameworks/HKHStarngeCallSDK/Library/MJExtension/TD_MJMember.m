//
//  MJMember.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "TD_MJMember.h"
#import "TD_MJExtension.h"
#import "TD_MJFoundation.h"
#import "TD_MJConst.h"

@implementation TD_MJMember


/**
 *  初始化
 *
 *  @param srcObject 来源于哪个对象
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithSrcObject:(id)srcObject
{
    if (self = [super init]) {
        _srcObject = srcObject;
    }
    return self;
}

- (void)setSrcClass:(Class)srcClass
{
    _srcClass = srcClass;
    
    MJAssertParamNotNil(srcClass);
    
    _srcClassFromFoundation = [TD_MJFoundation isClassFromFoundation:srcClass];
}

MJLogAllIvrs
@end
