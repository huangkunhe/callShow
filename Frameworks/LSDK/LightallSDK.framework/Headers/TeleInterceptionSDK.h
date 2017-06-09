//
//  TeleInterceptionSDK.h
//  TeleInterceptionSDK
//
//  Created by river on 2017/3/28.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSDKHeader.h"


@interface TeleInterceptionSDK : NSObject

/**
 *  是否号码库有更新
 *  @param successBlock 成功返回block
 *  @param errorBlock   成功返回block
 */
-(BOOL)isNeedUpdateStrangeCallsCompletion:(SCResultBlock)successBlock
                                  onError:(SCErrorBlock)errorBlock;

/**
 *  更新号码库
 */
-(void)updateStrangeCallsWithSuccess:(SCSimpleBlock)success
                         withFailure:(SCErrorBlock)failure
                        withProgress:(SCProgressBlock)progress;

/**
 *  获取来电号码信息
 
 *  返回值：所有标记电话号码
 */
-(NSArray *)getAllMarkedNumber;
-(NSArray *)getMarkedNumber:(long)from to:(long)to;

/**
 *  获取黑名单号码信息
 
 *  返回值：所有标记电话号码
 */
-(NSArray *)getAllBlackNumber;
-(NSArray *)getBlackNumber:(long)from to:(long)to;

/**
 *  添加标识号码到本地号码库
 *  @param callNumber 电话号码
 */
-(BOOL)markCallNumber:(NSString *)callNumber withInfo:(NSString *)info;

/**
 *  取消标识号码到本地号码库
 *  @param callNumber 电话号码
 */
-(BOOL)unMarkCallNumber:(NSString *)callNumber;

/**
 *  添加黑名单号码到本地号码库
 *  @param callNumber 电话号码
 */
-(BOOL)markBlackCallNumber:(NSString *)callNumber withInfo:(NSString *)info;

/**
 *  取消黑名单号码
 *  @param callNumber 电话号码
 */
-(BOOL)unMarkBlackCallNumber:(NSNumber *)callNumber;

-(BOOL)test;

@end
