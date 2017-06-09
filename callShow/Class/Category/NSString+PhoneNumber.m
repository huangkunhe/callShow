//
//  NSString+PhoneNumber.m
//  CaiYun
//
//  Created by Kane on 7/8/13.
//
//

#import "NSString+PhoneNumber.h"

@implementation NSString (PhoneNumber)

- (NSString *)plainPhoneNumber
{
    if (!self.length)
        return @"";

    /*
     NSString *result;
     //NSString *sample = @"010-123 456(789)(789)";
     NSString *regex = @"\\-|\\(|\\s|\\)";
     str = [str stringByReplacingOccurrencesOfRegex:regex withString:@""];
     NSMutableString *phone = [[str mutableCopy] autorelease];
     NSLog(@"replace: %@", phone);
     */

    BOOL flag = NO;
    for (int i = 0; i < [self length]; i++) {
        unichar aChar = [self characterAtIndex:i];
        if (aChar == ' ' || aChar == '(' || aChar == ')' || aChar == '-' || aChar == 0x00a0 ) {
            flag = YES;
            break;
        }
    }

    if (!flag) {
        //避免str 外部改变，重新开内存
        return [self mutableCopy];
    }

    NSMutableString *phone = [self mutableCopy];

    // 空格
    [phone replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@"(" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@")" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [phone length])];
    // tab
    [phone replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [phone length])];
    
    return phone;
}

// 去除以下特殊前缀：+86，86，12520，17951
- (NSString *)stripSpecicalPrefix
{
    if (!self.length)
        return @"";

    NSMutableString *phone = [self mutableCopy];

    if ([phone hasPrefix:@"+86"]) {
        [phone deleteCharactersInRange:NSMakeRange(0, 3)];
    } else if ([phone hasPrefix:@"86"]) {
        [phone deleteCharactersInRange:NSMakeRange(0, 2)];
    } else if ([phone hasPrefix:@"12593"]) {
        [phone deleteCharactersInRange:NSMakeRange(0, 5)];
    } else if ([phone hasPrefix:@"17951"]) {
        [phone deleteCharactersInRange:NSMakeRange(0, 5)];
    }

    return phone;
}

// 去除以下特殊字符：*，#
// 返回值：如果去掉特殊字符串，长度大于等于1，则为YES，否则为NO
- (BOOL)isValidLengthEnough
{
    if (self && self.length) {
        NSString *tmp = [self stringByReplacingOccurrencesOfString:@"*" withString:@""];
        tmp = [tmp stringByReplacingOccurrencesOfString:@"#" withString:@""];
        if (tmp && tmp.length > 0) {
            return YES;
        }
    }
    return NO;
}

// 取最后11位的号码
- (NSString *)filter11PhoneNumber
{
    if (!self.length)
        return @"";
    NSInteger offset = 0;
    if ((offset = self.length - 11) > 0) {
        return [self substringFromIndex:offset];
    }
    return self;
}

// 是否为手机号
- (BOOL)isPhoneNumber
{
    // ^ The start of the string, $ The end of the string.
    NSString *mobilePhoneNumber = @"^1(3[0-9]|4[57]|5[^4]|8[^4])\\d{8}$";

    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobilePhoneNumber] evaluateWithObject:self];
}

/**
 *  是否为短号（V网）
 *
 *  @return <#return value description#>
 */
- (BOOL)isShortNumber
{
    // ^ The start of the string, $ The end of the string.
    NSString *mobilePhoneNumber = @"^6\\d{5}$";
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobilePhoneNumber] evaluateWithObject:self];
}

/**
 *  是否为座机号码(0开头的11位和12位号码，包括区号)
 *
 *  @return <#return value description#>
 */
- (BOOL)isLandlineNumber
{
    BOOL isok = NO;
    if ((self.length == 11 || self.length == 12) && [self hasPrefix:@"0"]) {
        isok = YES;
    }
    return isok;
}

/**
 *  验证是否有效电话
 *
 *  @return <#return value description#>
 */
- (BOOL)isValidateMobile
{
    NSString *valideMobileRegex = @"(\\d|[-])+";//@"(\\d|[,;+#*])+";

    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", valideMobileRegex] evaluateWithObject:self];
}

/**
 *  是否为中国移动号码
 *
 *  @return <#return value description#>
 */
- (BOOL)isChinaMobileNumber
{
    NSString *MOBILE = @"^1(3[4-9]|5[012789]|8[23478])\\d{8}$"; //@"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE] evaluateWithObject:self];
}



@end
