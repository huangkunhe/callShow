
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "SettingButton.h"

@implementation SettingButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        // 设置按钮文字颜色
        [self setTitleColor:[UIColor colorWithLongHex:0x747474] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithLongHex:0x747474] forState:UIControlStateHighlighted];
        
        // 设置按钮文字位置
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        // 设置按钮文字的字体
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        // 设置图片效果
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setImage:[UIImage imageNamed:@"icon_right_arrow"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_right_arrow"] forState:UIControlStateHighlighted];
    }
    return self;
}

#pragma mark 控制UILabel的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.origin.y;
    CGFloat titleWidth = contentRect.size.width * (1-tkImageRatio)-tkImageGap;
    CGFloat titleHeight = contentRect.size.height;
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

#pragma mark 控制UIImageView的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = contentRect.size.width * (1-tkImageRatio);
    CGFloat imageY = contentRect.origin.y;
    CGFloat imageWidth = contentRect.size.width * tkImageRatio;
    CGFloat imageHeight = contentRect.size.height;
    
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

@end
