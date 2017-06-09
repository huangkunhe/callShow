
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "FileHelper.h"

@implementation FileHelper

#pragma mark 分析文件类型 (文件和目录)
+ (tkFileType)analyseFile:(NSString *)fileName fileType:(NSInteger)type
{
    if (nil == fileName) {
        return TYPE_NONE;
    }
    if (1 == type) {
        return TYPE_DIR;
    }
    return [self analyseFileNameSuffix:fileName];
}

#pragma mark 根据文件名获取文件类型
+ (tkFileType)analyseFileNameSuffix:(NSString *)fileName
{
    // 文件名转小写
    fileName = [fileName lowercaseString];
    if (nil != fileName && fileName.length > 0)
    {
        // 获得文件的后缀名(不带'.')
        NSString *ext = [fileName pathExtension];
        if ([@[@"doc", @"docx", @"pages"] containsObject:ext]) {
            return TYPE_DOC;
        }
        else if ([@[@"mp3", @"wav", @"mod", @"awf", @"flac", @"ape"] containsObject:ext]) {
            return TYPE_MUSIC;
        }
        else if([@[@"jpg", @"png", @"jpeg", @"bmp", @"gif",@"ico"] containsObject:ext]){
            return TYPE_IMG;
        }
        else if ([@[@"pdf"] containsObject:ext]) {
            return TYPE_PDF;
        }
        else if ([@[@"txt"] containsObject:ext]) {
            return TYPE_TEXT;
        }
        else if ([@[@"ppt", @"pptx", @"key"] containsObject:ext]) {
            return TYPE_PPT;
        }
        else if ([@[@"xls", @"xlsx", @"xlsm", @"xltx", @"xltm", @"xlsb", @"numbers"] containsObject:ext]) {
            return TYPE_XLS;
        }
        else if ([@[@"avi", @"mov", @"mp4", @"wmv", @"rmvb", @"flv", @"m4v", @"mkv"] containsObject:ext]){
            return TYPE_VIDEO;
        }
        else if ([@[@"zip", @"rar", @"7z"] containsObject:ext]){
            return TYPE_RAR;
        }
        else {
            return TYPE_OTHER;
        }
    }
    return TYPE_NONE;
}

#pragma mark 根据文件名获取文件类型图片
+ (UIImage *)analyseFileModelType:(NSString *)fileName fileType:(tkFileType)fileType
{
    UIImage *image = nil;
    switch (fileType) {
        case TYPE_DOC:
        {
            image = [UIImage imageNamed:@"icon_file_word.png"];
        }
            break;
        case TYPE_MUSIC:
        {
            image = [UIImage imageNamed:@"icon_file_music.png"];
        }
            break;
        case TYPE_IMG:
        {
            image = [UIImage imageNamed:@"icon_file_image.png"];
        }
            break;
        case TYPE_PDF:
        {
            image = [UIImage imageNamed:@"icon_file_pdf.png"];
        }
            break;
        case TYPE_TEXT:
        {
            image = [UIImage imageNamed:@"icon_file_txt.png"];
        }
            break;
        case TYPE_XLS:
        {
            image = [UIImage imageNamed:@"icon_file_excel.png"];
        }
            break;
        case TYPE_PPT:
        {
            image = [UIImage imageNamed:@"icon_file_ppt.png"];
        }
            break;
        case TYPE_VIDEO:
        {
            image = [UIImage imageNamed:@"icon_file_movie.png"];
        }
            break;
        case TYPE_RAR:
        {
            image = [UIImage imageNamed:@"icon_file_zip.png"];
            break;
        }
        case TYPE_DIR:
        {
            image = [UIImage imageNamed:@"icon_file_folder.png"];
            break;
        }
        case TYPE_OTHER:
        {
            image = [UIImage imageNamed:@"icon_file_unknown.png"];
        }
            break;
        default:
        {
            image = [UIImage imageNamed:@"icon_file_unknown.png"];
            break;
        }
    }
    
    return image;
}

#pragma mark 删除文件
+ (BOOL)deleteFile:(NSString *)filePath
{
    return [[NSFileManager defaultManager] deleteFile:filePath];
}

#pragma mark 移动文件
+ (BOOL)moveFile:(NSString *)filePath toPath:(NSString *)toPath
{
    return [[NSFileManager defaultManager] moveFile:filePath toPath:toPath];
}

#pragma mark 复制文件
+ (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)toPath
{
    return [[NSFileManager defaultManager] copyFile:filePath toPath:toPath];
}

#pragma mark 获取文件大小
+ (long long)getFileSize:(NSString *)path
{
    return [[NSFileManager defaultManager] getFileSize:path];
}

#pragma mark 判断文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark 格式化大小单位
+ (NSString *)fileSizeFormat:(long long)value
{
    return [[NSFileManager defaultManager] fileSizeFormat:value];
}

#pragma mark  随机生成文件名
+ (NSString *)getRandomFileName
{
    // yyyyMMddHHmmss+4位随机数
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]; // zh_CN en_US
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *randomString = [[NSString alloc] initWithFormat:@"%d",arc4random_uniform(1000)+1000];
    
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@%@", dateString, randomString];
    
    return fileName;
}

#pragma mark 用户家目录下序列化路径
+(NSString *)savePath:(NSString *)fileName
{
    // e.g.: /Library/Caches/RiverMail/mail.richinfo.cn
    NSString *subPath = [SC_CACHES stringByAppendingPathComponent:SCSDK];
    //NSLog(@"SavePath:%@",subPath);
    NSString *path = [[NSFileManager defaultManager] getLibrarySubDir:subPath];
    return [path stringByAppendingPathComponent:fileName];
}
+(NSString *)savePath:(NSString *)account wihtFileName:(NSString *)fileName
{
    // e.g.: /Library/Caches/RiverMail/mail.richinfo.cn/
    NSString *subPath = [SC_CACHES stringByAppendingPathComponent:SCSDK];
    subPath = [subPath stringByAppendingPathComponent:account];
    NSString *path = [[NSFileManager defaultManager] getLibrarySubDir:subPath];
    return [path stringByAppendingPathComponent:fileName];
}

@end
