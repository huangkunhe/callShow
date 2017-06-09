
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "UIColor+Think.h"

@implementation UIColor (Think)

#pragma mark 获取16进制的颜色
+ (UIColor *)colorWithLongHex:(long)hex;
{
    return [UIColor colorWithLongHex:hex alpha:1.0f];
}

#pragma mark 获取16进制的颜色(可设置透明值)
+ (UIColor *)colorWithLongHex:(long)hex alpha:(float)alpha;
{
    float red = (float) ((hex & 0xFF0000) >> 16) / 255.0 ;
    float green = (float) ((hex & 0xFF00) >> 8) / 255.0;
    float blue = (float) (hex & 0xFF) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark 以颜色值字符串方式转换颜色
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    return [UIColor colorFromHexRGB:inColorString alpha:1.0f];
}

#pragma mark 以颜色值字符串方式转换颜色(可设置透明值)
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end
