//
//  SCNetworkHelper.m
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "SCNetworkHelper.h"
#import "NSString+SC.h"
#import "TD_SSZipArchive.h"

@interface SCNetworkHelper()<NSURLSessionDownloadDelegate>

@property(nonatomic,copy) SCErrorObjectBlock failedBlock;

@property(nonatomic,copy) SCResultBlock finishedBlock;

@property(nonatomic,copy) SCProgressBlock progressBlock;

@end

@implementation SCNetworkHelper

-(BOOL)getGitUpdateVersion:(NSString *)downURLstr finished:(SCResultBlock)finished
{
    
    NSURL * downURL  = [NSURL URLWithString:downURLstr];
    // 创建会话对象
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *urlSessionDownloadTask = [urlSession downloadTaskWithURL:downURL completionHandler:^(NSURL *location,                                                         NSURLResponse *response,NSError *error) {
        if (error == nil) {
            NSLog(@"%@",location.path);
            //设置下载的文件存储路径
            NSString *documentsDirPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
         // 处理下载的数据
           BOOL unzip = [TD_SSZipArchive unzipFileAtPath:location.path toDestination: documentsDirPath];
            if (finished) {
                finished(unzip,documentsDirPath);
            }
        }
    }];
    // 执行任务
    [urlSessionDownloadTask resume];
    return YES;
}
//NSURLSessionDownloadTask *task
-(NSURLSessionDownloadTask *)getGitNumData:(NSString *)downURLstr progress:(SCProgressBlock)progress finished:(SCResultBlock)finished failed:(SCErrorObjectBlock)failed{
    
    _progressBlock = progress;
    _finishedBlock = finished;
    _failedBlock = failed;
    if (![downURLstr isValid]) {
        if (_failedBlock) {
            _failedBlock(nil);
            return nil;
        }
    }
    NSURL * downURL  = [NSURL URLWithString:downURLstr];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *urlSessionDownloadTask = [session downloadTaskWithURL:downURL];
    
    [urlSessionDownloadTask resume];
    
    return urlSessionDownloadTask;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"%@",location.path);
    //设置下载的文件存储路径
    NSString *documentsDirPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 处理下载的数据
    BOOL unzip = [TD_SSZipArchive unzipFileAtPath:location.path toDestination: documentsDirPath];
    if (self.finishedBlock) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                             stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
        self.finishedBlock(unzip,[docPath replaceCharcter:@".zip" withCharcter:@""]);
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    /**
     
     bytesWritten 本次下载数据的长度
     
     totalBytesWritten 总共下载的数据的长度 (已经下载了多少)
     
     totalBytesExpectedToWrite 文件的总长度
     
     */
    NSLog(@"%lld,%lld,%lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    
    if (self.progressBlock) {
        self.progressBlock(1.0*totalBytesWritten/totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (self.failedBlock) {
        self.failedBlock(error);
    }
}



@end
