
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "NSFileManager+TD.h"

@implementation NSFileManager (TD)

#pragma mark - 获取常用目录
- (NSString *)getDocument
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)getLibrary
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)getTemporary
{
    return NSTemporaryDirectory();
}

- (NSString *)getCaches
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - 获取常用子目录
- (NSString *)getDocumentSubDir:(NSString *)path
{
    NSString *dir = [[self getDocument] stringByAppendingPathComponent:path];
    if (![self fileExistsAtPath:dir]) {
        [self createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}

- (NSString *)getLibrarySubDir:(NSString *)path
{
    NSString *dir = [[self getLibrary] stringByAppendingPathComponent:path];
    if (![self fileExistsAtPath:dir]) {
        [self createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}

- (NSString *)getTemporarySubDir:(NSString *)path
{
    NSString *dir = [[self getTemporary] stringByAppendingPathComponent:path];
    if (![self fileExistsAtPath:dir]) {
        [self createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}

- (NSString *)getCachesSubDir:(NSString *)path
{
    NSString *dir = [[self getCaches] stringByAppendingPathComponent:path];
    if (![self fileExistsAtPath:dir]) {
        [self createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}

#pragma mark - 辅助方法
- (BOOL)deleteFile:(NSString *)filePath
{
    if ([self fileExistsAtPath:filePath])
    {
        return [self removeItemAtPath:filePath error:nil];
    }
    return NO;
}

- (BOOL)moveFile:(NSString *)filePath toPath:(NSString *)toPath
{
    if ([self fileExistsAtPath:filePath]) {
        return [self moveItemAtPath:filePath toPath:toPath error:nil];
    }
    return NO;
}

- (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)toPath
{
    if ([self fileExistsAtPath:filePath]) {
        return [self copyItemAtPath:filePath toPath:toPath error:nil];
    }
    return NO;
}

- (long long)getFileSize:(NSString *)path
{
    if([self fileExistsAtPath:path])
    {
        NSDictionary *attributes = [self attributesOfItemAtPath:path error:nil];
        NSNumber *fileSize;
        if ( (fileSize = [attributes objectForKey:NSFileSize]) )
            return  [fileSize longLongValue];
        else
            return -1;
    }
    else {
        return -1;
    }
}

- (NSString *)fileSizeFormat:(long long)value
{
    long GSize = 1 * 1024 * 1024 * 1024;
    long MBSize = 1 * 1024 * 1024;
    long KBSize = 1 * 1024;
    long long size = value;
    NSString *sizeString = nil;
    
    if (size >= GSize)
    {
        // 说明大小已经到G以上了
        double kb = size / 1024;
        double mb = kb / 1024;
        double G = mb / 1024;
        sizeString = [NSString stringWithFormat:@"%.2fG",G];
    }
    else if (size > MBSize)
    {
        // 说明大小在M 和 G 之间
        double kb = size / 1024;
        double mb = kb / 1024;
        sizeString = [NSString stringWithFormat:@"%.1fMB",mb];
    }
    else if (size > KBSize)
    {
        long long kb = size / 1024;
        sizeString = [NSString stringWithFormat:@"%zdKB",kb];
    }
    else if (size <= KBSize)
    {
        long long kb = size;
        sizeString = [NSString stringWithFormat:@"%zdB",kb];
    }
    
    return sizeString;
}

- (BOOL)checkFileAlreadyDownload:(NSString *)filePath size:(long long)fileSize
{
    NSError *error = nil;
    NSDictionary *dictFile = [self attributesOfItemAtPath:filePath error:&error];
    if (error) {
        //NSLog(@"文件不存在:%@", error);
        return NO;
    }
    long long nFileSize = [dictFile fileSize]; // 得到文件大小
    if (nFileSize == fileSize) {
        return YES;
    }
    return NO;
}

+ (BOOL)createDirFromPath:(NSString *)path error:(NSError *__autoreleasing *)error
{
    if (nil == path || [path isEqualToString:@""]) {
        return NO;
    }
    return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:error];
}

@end
