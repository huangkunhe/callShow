//
//  CSHeaderView.m
//  callShow
//
//  Created by river on 2017/3/31.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "CSHeaderView.h"
#import "SXWaveView.h"
#import "CSRadarScannedView.h"

@interface CSHeaderView()<SXViewAdditionsDelegate>

@property (strong, nonatomic) CSRadarScannedView *radarScannedView;

@property (strong, nonatomic) SXWaveView *waveView;

@end

@implementation CSHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:KGreenStyleColor];
    }
    return self;
}

-(CSRadarScannedView *)radarScannedView{
    if (_radarScannedView == nil) {
        _radarScannedView = [[CSRadarScannedView alloc]initWithFrame:CGRectMake(50, self.frame.size.height-(self.frame.size.width-50), self.frame.size.width-100, self.frame.size.width-100)];
    }
    return _radarScannedView;
}

-(SXWaveView *)waveView
{
    if (_waveView ==nil) {
            _waveView = [[SXWaveView alloc]initWithFrame:CGRectMake(50, tkScreenHeight-(tkScreenWidth-50), tkScreenWidth-100, tkScreenWidth-100)];
        _waveView.delegate =self;
            [_waveView setPrecent:0 description:@"点击更新号码" textColor:[UIColor whiteColor] bgColor:KGreenStyleColor alpha:0.2 clips:YES];
            [_waveView setEndless:YES];
            [_waveView setUpdating:NO];
            [_waveView addAnimateWithType:0];
    }
    return _waveView;
}

-(void)showRadarScannedView{
    
    [UIView animateWithDuration:10 animations:^{
        if (_waveView !=nil) {
            [self.waveView removeFromSuperview];
            _waveView =nil;
        }
        [self.radarScannedView removeFromSuperview];
        [self addSubview:self.radarScannedView];
    }];
    
}

-(void)showWaveView{
    
    if (_radarScannedView !=nil) {
        [self.radarScannedView removeFromSuperview];
        _radarScannedView =nil;
    }
    [self.waveView removeFromSuperview];
    [self addSubview:self.waveView];
}

-(void)setPrecent:(CGFloat)precent{
    
    [self.waveView setPrecent:precent];
    [_waveView addAnimate];
}

-(void)setDownStatus:(tkDownStatus)status{
    if (status == tkDowning) {
        [self.waveView setDescriptionTxt:@"下载过程中，请稍后"];
        return;
    }
    if (status == tkDownCheck) {
        [self.waveView setDescriptionTxt:@"检查更新，请稍后"];
        return;
    }
    if (status == tkDownCheck) {
        [self.waveView setDescriptionTxt:@"请点击更新号码"];
        return;
    }


}

#pragma mark SXViewAdditionsDelegate

-(void)chickdescriptionTxtDelegate:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(chickDownDelegate:)]) {
        if ([text isEqualToString:@"点击更新号码"]) {
            
            [self.delegate chickDownDelegate:tkDownReady];
        }else
        {
             [self.delegate chickDownDelegate:tkDowning];
        }
        
    }
}

@end
