//
//  LightallSDK.h
//  LightallSDK
//
//  Created by river on 2017/3/28.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TeleInterceptionSDK.h"
#import "SCModel.h"
#import "SCPhoneNumber.h"


//! Project version number for LightallSDK.
FOUNDATION_EXPORT double LightallSDKVersionNumber;

//! Project version string for LightallSDK.
FOUNDATION_EXPORT const unsigned char LightallSDKVersionString[];

typedef void (^SCSuccessBlock) (NSDictionary *resultDic);
typedef void (^SCErrorBlock) (NSInteger code, NSString *message);
typedef void (^SCResultBlock) (BOOL result,NSString * path);
typedef void (^SCSimpleBlock) ();
typedef void (^SCObjectBlock) (id object);
typedef void (^SCErrorObjectBlock)(NSError *error);
typedef void (^SCProgressBlock)(double progress);

// In this header, you should import all the public headers of your framework using statements like #import <LightallSDK/PublicHeader.h>
//lipo -create Release-iphoneos/LightallSDK.framework/LightallSDK Release-iphonesimulator/LightallSDK.framework/LightallSDK -output Release-iphoneos/LightallSDK.framework/LightallSDK


