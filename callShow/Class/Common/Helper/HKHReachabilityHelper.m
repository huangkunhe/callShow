
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "HKHReachabilityHelper.h"

@implementation HKHReachabilityHelper

#pragma mark 检查网络情况
+ (void)currentReachabilityStatus:(void(^)(NetworkStatus status))statusBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TDReachability *reachability = [TDReachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusBlock) {
                statusBlock(internetStatus);
            }
        });
    });
}

#pragma mark 启动网络监听
+ (BOOL)startNotifier
{
    TDReachability *reachability = [TDReachability reachabilityForInternetConnection];
    return [reachability startNotifier];
}

#pragma mark 
+ (void)stopNotifier
{
    TDReachability *reachability = [TDReachability reachabilityForInternetConnection];
    [reachability stopNotifier];
}

@end
