//
//  Created by river on 2017/3/31.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <InMobiSDK/InMobiSDK.h>
#import "AppDelegate.h"

@interface HKHViewController : UIViewController


@property (nonatomic, assign, getter=isBackButton) BOOL backButton;   // 是否有导航栏返回按钮(默认为YES)
@property (nonatomic, assign, getter=isDissmButton) BOOL dissmButton; // 是否有取消模态返回按钮(默认为NO)
/**
 *  VIEW是否渗透导航栏
 * (YES_VIEW渗透导航栏下／NO_VIEW不渗透导航栏下)
 */
@property (assign,nonatomic) BOOL isExtendLayout;

@property(nonatomic,strong) IMBanner *banner;


/**
 * 功能：设置修改StatusBar
 * 参数：（1）StatusBar样式：statusBarStyle
 *      （2）是否隐藏StatusBar：statusBarHidden
 *      （3）是否动画过渡：animated
 */

-(void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle
            statusBarHidden:(BOOL)statusBarHidden
    changeStatusBarAnimated:(BOOL)animated;

/**
 * 功能：隐藏显示导航栏
 * 参数：（1）是否隐藏导航栏：isHide
 *      （2）是否有动画过渡：animated
 */
-(void)hideNavigationBar:(BOOL)isHide
                animated:(BOOL)animated;

/**
 * 功能： 布局导航栏界面
 * 参数：（1）导航栏背景：backGroundImage
 *      （2）导航栏标题颜色：titleColor
 *      （3）导航栏标题字体：titleFont
 *      （4）导航栏左侧按钮：leftItem
 *      （5）导航栏右侧按钮：rightItem
 */
-(void)layoutNavigationBar:(UIImage*)backGroundImage
                titleColor:(UIColor*)titleColor
                 titleFont:(UIFont*)titleFont
         leftBarButtonItem:(UIBarButtonItem*)leftItem
        rightBarButtonItem:(UIBarButtonItem*)rightItem;

- (void)showTextOnly:(NSString *)text;


-(void)addBanner;
-(void)addBanner2;

// 获取appDelegate对象
- (AppDelegate *)appDelegate;

@end
