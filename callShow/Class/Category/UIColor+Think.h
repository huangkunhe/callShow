
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import <UIKit/UIKit.h>

@interface UIColor (Think)

/**
 *	获取16进制的颜色
 *
 *	@param 	hex 0xfffff
 *
 *	@return	返回16进制的颜色
 */
+ (UIColor *)colorWithLongHex:(long)hex;

/**
 *	获取16进制的颜色(可设置透明值)
 *
 *	@param 	hex 0xfffff
 *	@param 	alpha 透明度
 *
 *	@return	返回16进制颜色
 */
+ (UIColor *)colorWithLongHex:(long)hex alpha:(float)alpha;

/**
 *  以颜色值字符串方式转换颜色
 *
 *  @param inColorString 颜色值字符串
 *
 *  @return 返回16进制颜色
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

/**
 *  以颜色值字符串方式转换颜色(可设置透明值)
 *
 *  @param inColorString 颜色值字符串
 *  @param alpha         透明度
 *
 *  @return 返回16进制颜色
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha;

@end
