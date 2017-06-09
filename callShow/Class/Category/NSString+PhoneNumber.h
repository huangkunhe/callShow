//
//  NSString+PhoneNumber.h
//  CaiYun
//
//  Created by Kane on 7/8/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (PhoneNumber)

// 去除以下特殊字符：空格，括号()，-
- (NSString *)plainPhoneNumber;

// 去除以下特殊前缀：+86，86，12520，17951
- (NSString *)stripSpecicalPrefix;

// 去除以下特殊字符：*，#
// 返回值：如果去掉特殊字符串，长度大于等于3，则为YES，否则为NO
- (BOOL)isValidLengthEnough;

// 取最后11位的号码
- (NSString *)filter11PhoneNumber;

// 是否为手机号
- (BOOL)isPhoneNumber;

/**
 *  是否为短号（V网）
 *
 *  @return <#return value description#>
 */
- (BOOL)isShortNumber;


/**
 *  验证是否有效电话
 *
 *  @return <#return value description#>
 */
- (BOOL)isValidateMobile;

/**
 *  是否为座机号码(0开头的11位和12位号码，包括区号)
 *
 *  @return <#return value description#>
 */
- (BOOL)isLandlineNumber;

/**
 *  是否为中国移动号码
 *
 *  @return <#return value description#>
 */
- (BOOL)isChinaMobileNumber;

@end
