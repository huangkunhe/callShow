//
//  Created by river on 2017/3/31.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "HKHNavigationController.h"

@interface HKHNavigationController ()

@end

@implementation HKHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


/**
 *  加载导航栏背景图
 */
//- (void)loadNavigationBar
//{
//    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        NSString *imageName = nil;
//        self.view.backgroundColor = [UIColor whiteColor];
//       
//        
//        // 移除导航栏底部阴影
//        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//        
//        // 设置控件全局显示样式appearance proxy
//        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
//        UIImage *image = [UIImage imageNamed:imageName];
//        image = [image stretchableImageWithLeftCapWidth:1/2.0 topCapHeight:44/2.0];
//        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setTitleTextAttributes:dict];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
    return self.topViewController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
