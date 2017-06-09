//
//  Created by river on 2017/3/31.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "HKHViewController.h"
#import "MBProgressHUD.h"

// 默认延迟时间
#define tkMessageDelay 1.5f

// 提示背景透明度
#define tkMessageBgAlpha 0.96f

// 颜色函数
#define tkMessageColor(r,g,b,a) [UIColor colorWithRed:r/250.0 green:g/250.0 blue:b/250.0 alpha:a]

@interface HKHViewController ()<MBProgressHUDDelegate>

@property (nonatomic, weak) MBProgressHUD *HUD;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) BOOL changeStatusBarAnimated;

@end



@implementation HKHViewController

-(IMBanner *)banner
{
    if (_banner == nil) {
        _banner =[[IMBanner alloc] initWithFrame:CGRectMake(0,tkScreenHeight-110, tkScreenWidth, 50) placementId:INMOBI_BANNERID];
        [_banner load];
    }
    return _banner;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    HKHViewController *viewController = [super allocWithZone:zone];
    
    return viewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setIsExtendLayout:NO];
    
    UIFont * font=[UIFont fontWithName:@"MicrosoftYaHei" size:(18)];
    [self layoutNavigationBar:[UIImage imageNamed:@"navigationBarBG@2x.png"]titleColor:[UIColor whiteColor] titleFont:font leftBarButtonItem:nil rightBarButtonItem:nil];
    [self loadNavigationButton];
    self.navigationController.navigationBar.barTintColor = KGreenStyleColor;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.view.backgroundColor =[UIColor whiteColor];
    
  
}


-(void)addBanner
{
    if (kIsOpenADError) {
        [self.banner removeFromSuperview];
        [self.view addSubview:self.banner];
    }
}

-(void)addBanner2
{
    // 广告插入
    [self.view addSubview:self.banner];
}

#pragma mark - system

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.statusBarStyle) {
        
        return self.statusBarStyle;
    } else {
        
        return UIStatusBarStyleLightContent;
    }
}

- (BOOL)prefersStatusBarHidden {
    
    return self.statusBarHidden;
}

- (void)dealloc {
    [self destruct];
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

#pragma mark - private

- (void)setIsExtendLayout:(BOOL)isExtendLayout {
    
    if (!isExtendLayout) {
        [self initializeSelfVCSetting];
    }
}

- (void)initializeSelfVCSetting {
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}

- (void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle
             statusBarHidden:(BOOL)statusBarHidden
     changeStatusBarAnimated:(BOOL)animated {
    
    self.statusBarStyle=statusBarStyle;
    self.statusBarHidden=statusBarHidden;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
    else{
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)hideNavigationBar:(BOOL)isHide
                 animated:(BOOL)animated{
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.navigationController.navigationBarHidden=isHide;
        }];
    }
    else{
        self.navigationController.navigationBarHidden=isHide;
    }
}

- (void)layoutNavigationBar:(UIImage*)backGroundImage
                 titleColor:(UIColor*)titleColor
                  titleFont:(UIFont*)titleFont
          leftBarButtonItem:(UIBarButtonItem*)leftItem
         rightBarButtonItem:(UIBarButtonItem*)rightItem {
    
    if (backGroundImage) {
        [self.navigationController.navigationBar setBackgroundImage:backGroundImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }else
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
    if (titleColor&&titleFont) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:titleFont}];
    }
    else if (titleFont) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:titleFont}];
    }
    else if (titleColor){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];
    }
    if (leftItem) {
        self.navigationItem.leftBarButtonItem=leftItem;
    }
    if (rightItem) {
        self.navigationItem.rightBarButtonItem=rightItem;
    }
    // 移除导航栏底部阴影
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
//////////////////////////////////////////////////////////////////////////
#pragma mark - 提示信息
#pragma mark 纯文本提示信息(默认1.5秒自动关闭提示)
- (void)showTextOnly:(NSString *)text
{
    [self showTextOnly:text afterDelay:tkMessageDelay];
}

- (void)initHUD
{
    if (nil == self.HUD)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (nil == window) {
            return;
        }
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
        [HUD setDelegate:self];
        [HUD setRemoveFromSuperViewOnHide:YES];
        [window addSubview:HUD];
        self.HUD = HUD;
    }
}
#pragma mark 延迟关闭纯文本提示信息
- (void)showTextOnly:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    [self initHUD];
    
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = text;
    self.HUD.margin = 10.0f;
    
    [self.HUD show:YES];
    [self hideAfterDelay:delay];
}

#pragma mark 关闭提示
- (void)hide
{
    [self.HUD hide:YES];
}

- (void)hideAfterDelay:(NSTimeInterval)delay
{
    [self.HUD hide:YES afterDelay:delay];
}

#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self destruct];
}
#pragma mark 消息工具释放资源
- (void)destruct
{
    if (nil != self.HUD)
    {
        [self.HUD removeFromSuperview];
        self.HUD.delegate = nil;
        self.HUD = nil;
    }
}
//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 初始化界面
- (void)loadNavigationButton
{
    // 导航栏item间隔
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    CGFloat width = 0;
    if (IS_IOS7_OR_LATER) {
        width = -20.0;
    }
    fixedSpace.width = width;
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ((self.backButton && viewControllers.count > 1) || self.dissmButton)
    {
        // 返回按钮
        UIButton *backButton=[UIButton new];
        [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateSelected];
        
        backButton.frame = CGRectMake(0, 0, 45.0, 44.0);
        backButton.showsTouchWhenHighlighted = NO;
        if (self.isDissmButton) {
            [backButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItems = @[fixedSpace,backItem];
        
    }
}

- (void)backAction:(UIButton *)button
{
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismissAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark 获取AppDelegate对象
- (AppDelegate *)appDelegate
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

#pragma mark - 屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
