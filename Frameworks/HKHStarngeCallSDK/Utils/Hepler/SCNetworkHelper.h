//
//  SCNetworkHelper.h
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSDKHeader.h"

@interface SCNetworkHelper : NSObject

-(BOOL)getGitUpdateVersion:(NSString *)downURLstr finished:(SCResultBlock)finished;

-(NSURLSessionDownloadTask *)getGitNumData:(NSString *)downURLstr progress:(SCProgressBlock)progress finished:(SCResultBlock)finished failed:(SCErrorObjectBlock)failed;

@end
