
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

@interface NSFileManager (TD)

/**
 *	获取常用目录
 *
 *	@return	目录
 */
- (NSString *)getDocument;
- (NSString *)getLibrary;
- (NSString *)getTemporary;
- (NSString *)getCaches;

/**
 *  获取常用子目录
 *
 *  @param path 子目录
 *
 *  @return 目录
 */
- (NSString *)getDocumentSubDir:(NSString *)path;
- (NSString *)getLibrarySubDir:(NSString *)path;
- (NSString *)getTemporarySubDir:(NSString *)path;
- (NSString *)getCachesSubDir:(NSString *)path;

/**
 *  删除文件
 *
 *  @param filePath 文件路径
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteFile:(NSString *)filePath;

/**
 *  移动文件
 *
 *  @param filePath 文件路径
 *  @param toPath   移动路径
 *
 *  @return 是否移动成功
 */
- (BOOL)moveFile:(NSString *)filePath toPath:(NSString *)toPath;

/**
 *  复制文件
 *
 *  @param filePath 文件路径
 *  @param toPath   复制路径
 *
 *  @return 是否复制成功
 */
- (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)toPath;

/**
 *  获取文件大小
 *
 *  @param path 文件路径
 *
 *  @return 文件大小(单位字节)
 */
- (long long)getFileSize:(NSString *)path;

/**
 *  格式化大小单位
 *
 *  @param value 字节数
 *
 *  @return 格式化字符串
 */
- (NSString *)fileSizeFormat:(long long)value;

/**
 *  检测目录下文件是否已经下载
 *
 *  @param filePath    文件路径
 *  @param fileSize    文件大小
 *
 *  @return 是否下载状态
 */
- (BOOL)checkFileAlreadyDownload:(NSString *)filePath size:(long long)fileSize;

+ (BOOL)createDirFromPath:(NSString *)path error:(NSError *__autoreleasing *)error;

@end
