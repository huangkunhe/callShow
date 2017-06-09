//
//  CSHeaderView.h
//  callShow
//
//  Created by river on 2017/3/31.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, tkDownStatus) {
    tkDownReady= 0,//点击后处理下载流程
    tkDowning, //无效点击
    tkDownCheck
};

@protocol CSHeaderViewDelegate <NSObject>
@optional
- (void)chickDownDelegate:(tkDownStatus)status;
@end

@interface CSHeaderView : UIView

@property (nonatomic, assign) id<CSHeaderViewDelegate> delegate;

-(void)showRadarScannedView;

-(void)showWaveView;

-(void)setPrecent:(CGFloat)precent;

-(void)setDownStatus:(tkDownStatus)status;

@end
