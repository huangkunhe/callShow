//
//  HKHStarngeCallSDK.m
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "HKHStarngeCallSDK.h"
#import "SCNetworkHelper.h"

@implementation HKHStarngeCallSDK


-(BOOL)isNeedUpdateStrangeCallsCompletion:(SCResultBlock)successBlock
                                  onError:(SCErrorBlock)errorBlock
{
    //本地检查
    NSArray * nums =[[TDEntity sharedTDEntity] queryWithClass:[SCVersionModel class] condition:nil sqlOrder:nil];
    
    NSString *cachePath = [CacheVersionDataPath stringByAppendingPathComponent:kNumVersionDataVersionflie];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([nums count] > 0) {
        
        
        if ([fileManager fileExistsAtPath:cachePath]) {
            NSDictionary *resultObj = [NSDictionary dictionaryWithContentsOfFile:cachePath];
            NSLog(@"%@",resultObj);
            //3、进行与本地数据对比
            SCVersionModel * oldModel = nums[0];
            SCVersionModel * model = [SCVersionModel modelWithDictionary:resultObj];
            if ([model.version intValue] >[oldModel.version intValue])
            {
                if (successBlock) {
                    successBlock(YES,cachePath);
                    return YES;
                }
            }
        }
    }
    //当本地数据库等于本地配置文件 或数据库无数据、无配置的时候，需要请求配置信息
    //1、网络请求配置信息
    [[SCNetworkHelper new] getGitUpdateVersion:kNumVersionDataHost finished:^(BOOL result, NSString *path) {
        if (result) {
            //2、进行数据获取
            if ([fileManager fileExistsAtPath:cachePath]) {
                 NSDictionary *resultObj = [NSDictionary dictionaryWithContentsOfFile:cachePath];
                NSLog(@"%@",resultObj);
                //3、进行与本地数据对比
                SCVersionModel * model = [SCVersionModel modelWithDictionary:resultObj];
                if ([nums count] <= 0 ) {
                    if (successBlock) {
                        successBlock(YES,cachePath);
                    }
                }else
                {
                    SCVersionModel * oldModel = nums[0];
                    if ([model.version intValue] >[oldModel.version intValue]) {
                        if (successBlock) {
                            successBlock(YES,cachePath);
                        }
                    }else
                    {
                        if (successBlock) {
                            successBlock(NO,cachePath);
                        }
                    }
                }
            }
            
        }else
        {
            if (errorBlock) {
                errorBlock(500,kErrorMessage);
            }
        }
    }];
    return YES;
}

-(void)updateStrangeCallsWithSuccess:(SCSimpleBlock)success
                         withFailure:(SCErrorBlock)failure
                        withProgress:(SCProgressBlock)progress
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *vpath = [CacheVersionDataPath stringByAppendingPathComponent:kNumVersionDataVersionflie];
    NSString * hostUrl =@"";
    if ([fileManager fileExistsAtPath:vpath]) {
        NSDictionary *resultObj = [NSDictionary dictionaryWithContentsOfFile:vpath];
        SCVersionModel * model = [SCVersionModel modelWithDictionary:resultObj];
        hostUrl = model.downurl;
    }
    [[SCNetworkHelper new]getGitNumData:hostUrl progress:^(double doub) {
        
        if (progress) {
            progress(doub*0.7);
        }
        
    } finished:^(BOOL result, NSString *path) {
        if (result) {
            NSString * ppath =[path stringByAppendingPathComponent:kNumDataVersionflie];
            if ([fileManager fileExistsAtPath:ppath]) {
                NSDictionary *dicObj = [NSDictionary dictionaryWithContentsOfFile:ppath];
                NSArray *resultObj = dicObj[@"markList"];
                NSLog(@"%@",resultObj);
                //1、删除本地数据
                [[TDEntity sharedTDEntity]deleteWithClass:[SCPhoneNumber class] condition:@{@"source!=":kMY}];
                //2、保存号码数据
                for (int i=0; i < resultObj.count; i++){
                    SCPhoneNumber * num =  [SCPhoneNumber modelWithDictionary:(NSDictionary *)resultObj[i]];
                    [[TDEntity sharedTDEntity]saveWithClass:[SCPhoneNumber class] model:num];
                    if (progress) {
                        progress(0.7+0.2*i/resultObj.count);
                    }
                }
                //3、更新本地配置
                if ([fileManager fileExistsAtPath:vpath]) {
                    [[TDEntity sharedTDEntity]deleteWithClass:[SCVersionModel class] condition:nil];
                    NSDictionary *resultObj = [NSDictionary dictionaryWithContentsOfFile:vpath];
                    SCVersionModel * model = [SCVersionModel modelWithDictionary:resultObj];
                    [[TDEntity sharedTDEntity]saveWithClass:[SCVersionModel class] model:model];
                }
                
                if (progress) {
                   progress(0.7+0.2+0.1);
                }
                if (success) {
                    success();
                }
                
                }else
                {
                    if (failure) {
                        failure(500,kErrorMessage);
                    }
                }
        }else
        {
            if (failure) {
                failure(500,kErrorMessage);
            }
        }
        
    } failed:^(NSError *error) {
        if (error) {
            if (failure) {
                
                failure(error.code,error.domain);
            }
        }
    }];
}

-(NSArray *)getAllMarkedNumber{
    return [[TDEntity sharedTDEntity]queryWithClass:[SCPhoneNumber class] condition:nil sqlOrder:@"ORDER BY phone ASC"];
}

-(BOOL)markCallNumber:(NSNumber *)callNumber withInfo:(NSString *)info
{
    SCPhoneNumber * num = [SCPhoneNumber new];
    num.phone =callNumber;
    num.mark = info;
    num.tagStr =kMrakList;
    num.source = kMY;
    return [[TDEntity sharedTDEntity]saveWithClass:[SCPhoneNumber class] model:num];
}

-(BOOL)unMarkCallNumber:(NSNumber *)callNumber
{
    return [[TDEntity sharedTDEntity]deleteWithClass:[SCPhoneNumber class] condition:@{@"phone":callNumber,@"tagStr":kMrakList}];

}

-(BOOL)markBlackCallNumber:(NSNumber *)callNumber withInfo:(NSString *)info
{
    SCPhoneNumber * num = [SCPhoneNumber new];
    num.phone =callNumber;
    num.mark = info;
    num.tagStr =kBlackList;
    num.source = kMY;
   return [[TDEntity sharedTDEntity]saveWithClass:[SCPhoneNumber class] model:num];
}

-(BOOL)unMarkBlackCallNumber:(NSNumber *)callNumber{
    return [[TDEntity sharedTDEntity]deleteWithClass:[SCPhoneNumber class] condition:@{@"phone":callNumber,@"tagStr":kBlackList}];
}

@end
