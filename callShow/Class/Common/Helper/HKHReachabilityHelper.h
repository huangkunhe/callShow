
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "TD_Reachability.h"

/**
 *  网络监听工具类
 */
@interface HKHReachabilityHelper : NSObject

/**
 *  检查网络情况
 *
 *  @param statusBlock 网络状态回调
 */
+ (void)currentReachabilityStatus:(void(^)(NetworkStatus status))statusBlock;

/**
 * 启动网络监听
 */
+ (BOOL)startNotifier;

/**
 * 关闭网络监听
 */
+ (void)stopNotifier;

@end
