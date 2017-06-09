//
//  HelpViewController.m
//  callShow
//
//  Created by river on 2017/4/5.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<IMInterstitialDelegate>
@property(nonatomic,strong) UIScrollView *strangCallGuide;

@property (nonatomic, strong) IMInterstitial *interstitial;
@end

@implementation HelpViewController

- (UIScrollView *)strangCallGuide {
    if (_strangCallGuide == nil) {
        UIImage *settingImage1 = [UIImage imageNamed:@"help1"];
        CGFloat settingImageW = tkScreenWidth;
        CGFloat settingImageH = 1008;
        UIImageView *settingImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tkScreenWidth, settingImageH)];
        settingImageView1.image = settingImage1;
        _strangCallGuide = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, tkScreenWidth, tkScreenHeight)];
        UIImage *settingImage2 = [UIImage imageNamed:@"help2"];
        UIImageView *settingImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, settingImageH, tkScreenWidth, settingImageH)];
        settingImageView2.image = settingImage2;
        _strangCallGuide = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, tkScreenWidth, tkScreenHeight)];
        _strangCallGuide.contentSize = CGSizeMake(settingImageW, 2100);
        [_strangCallGuide addSubview:settingImageView1];
         [_strangCallGuide addSubview:settingImageView2];
        _strangCallGuide.backgroundColor = [UIColor whiteColor];
        _strangCallGuide.hidden = NO;
    }
    
    return _strangCallGuide;
}

-(IMInterstitial *)interstitial
{
    if (_interstitial == nil) {
        _interstitial = [[IMInterstitial alloc] initWithPlacementId:INMOBI_INTERSTITIALID];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用说明";
    if (kIsOpenADError){
        
        [self.interstitial load];
    }
    
    [self.view addSubview:self.strangCallGuide];
    [self addBanner];
}

-(void)initView{
    UIImageView * helpView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"help1"]];
    helpView1.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:helpView1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Interstitial Interaction Notifications
/**
 * Notifies the delegate that the ad server has returned an ad. Assets are not yet available.
 * Please use interstitialDidFinishLoading: to receive a callback when assets are also available.
 */
-(void)interstitialDidReceiveAd:(IMInterstitial *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial has finished loading
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial {
    if (kIsOpenADError) {
        [interstitial showFromViewController:self withAnimation:kIMInterstitialAnimationTypeNone];
        double delayInSeconds = 3.0;
        
        dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(poptime, dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:YES completion:^{}];
            
        });
    }
}
/**
 * The interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error {
    NSString *errorMessage = [NSString stringWithFormat:@"Loading ad failed. Error code: %ld, message: %@",  (long)[error code], [error localizedDescription]];
    NSLog(@"%@", errorMessage);
    
}
/**
 * The interstitial would be presented.
 */
-(void)interstitialWillPresent:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial has been presented.
 */
-(void)interstitialDidPresent:(IMInterstitial *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial has failed to present with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToPresentWithError:(IMRequestStatus*)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial has been dismissed.
 */
-(void)interstitialDidDismiss:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);

}
/**
 * The interstitial has been interacted with.
 */
-(void)interstitial:(IMInterstitial*)interstitial didInteractWithParams:(NSDictionary*)params {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"params : %@", params);
}
/**
 * The user has performed the action to be incentivised with.
 */
-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"rewards : %@", rewards);
}
/**
 * The user will leave application context.
 */
-(void)userWillLeaveApplicationFromInterstitial:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
