//
//  CSRadarScannedView.m
//  callShow
//
//  Created by river on 2017/3/31.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "CSRadarScannedView.h"

@interface CSRadarScannedView()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CSRadarScannedView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
//        [self setBackgroundColor:KGreenStyleColor];
        [self addSubview:self.imageView];
        [self startImageView];
    }
    return self;
}

-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        _imageView.contentMode =UIViewContentModeScaleToFill;
        [_imageView setImage:[UIImage imageNamed:@"scanPartCircle.png"]];
    }
    return _imageView;
}


- (void)startImageView {
    
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 5;
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    animation.repeatCount = HUGE;
    animation.cumulative = true;
    animation.removedOnCompletion = NO;
    [self.imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
    
}

@end
