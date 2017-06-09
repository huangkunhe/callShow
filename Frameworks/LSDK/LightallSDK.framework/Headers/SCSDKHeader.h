//
//  SCSDKHeader.h
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#ifndef SCSDKHeader_h
#define SCSDKHeader_h


#define KInterfaceVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] //   @"1.0"
#define UserDefaults        [NSUserDefaults standardUserDefaults]

#ifdef __OPTIMIZE__
#define NSLog(...)
#endif

#ifndef __OPTIMIZE__
#ifndef DLog
#define DLog(fmt, ...) {NSLog((@"\n%s [Line %d]\n " fmt @"\n\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define DLogObject(object) DLog("%@", object);
#define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#define DLog(...)
#define DLogObject(object)
#define ELog(err)
#endif
#endif

typedef void (^SCSuccessBlock) (NSDictionary *resultDic);
typedef void (^SCErrorBlock) (NSInteger code, NSString *message);
typedef void (^SCResultBlock) (BOOL result,NSString * path);
typedef void (^SCSimpleBlock) ();
typedef void (^SCObjectBlock) (id object);
typedef void (^SCErrorObjectBlock)(NSError *error);
typedef void (^SCProgressBlock)(double progress);


//
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


#endif /* SCSDKHeader_h */
