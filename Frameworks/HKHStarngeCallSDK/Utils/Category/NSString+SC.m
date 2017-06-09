//
//  NSString+SC.m
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "NSString+SC.h"

@implementation NSString (SC)

#pragma mark - NSString+PJR相关
// Checking if String is Empty
- (BOOL)isBlank
{
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}
//Checking if String is empty or nil
- (BOOL)isValid
{
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"] || [self length] <= 0 || self == (id)[NSNull null]) ? NO :YES;
}

// remove white spaces from String
- (NSString *)removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

#pragma mark 替换字符串
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar
{
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

@end
