
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

// 文件细分类型
typedef NS_ENUM(NSInteger, tkFileType) {
    TYPE_NONE = 1,
    TYPE_MUSIC,
    TYPE_TEXT,
    TYPE_IMG,
    TYPE_DOC,
    TYPE_DOCX,
    TYPE_PNG,
    TYPE_JPG,
    TYPE_JPEG,
    TYPE_FOLD,
    TYPE_WPS,
    TYPE_TXT,
    TYPE_XLS,
    TYPE_PDF,
    TYPE_PPT,
    TYPE_OTHER,
    TYPE_RAR,
    TYPE_VIDEO,
    TYPE_DIR
};

//// 文件归类
//typedef NS_ENUM(NSInteger, tkFileSort) {
//    SORT_ALL = 0,
//    SORT_FILE,
//    SORT_PICTURE,
//    SORT_VIDEO,
//    SORT_MUSIC,
//    SORT_OTHER
//};

@interface FileHelper : NSObject

/**
 *  分析文件类型 (文件和目录)
 *
 *  @param fileName 文件名称
 *  @param type     文件类型(接口返回1:文件夹 2:文件)
 *
 *  @return 文件类型
 */
+ (tkFileType)analyseFile:(NSString *)fileName fileType:(NSInteger)type;

/**
 *  根据文件名获取文件类型
 *
 *  @param fileName 文件名称
 *
 *  @return 文件类型
 */
+ (tkFileType)analyseFileNameSuffix:(NSString *)fileName;

/**
 *  根据文件名获取文件类型图片
 *
 *  @param fileName 文件名称
 *
 *  @return 图片对象
 */
+ (UIImage *)analyseFileModelType:(NSString *)fileName fileType:(tkFileType)fileType;

/**
 *  删除文件
 *
 *  @param filePath 文件路径
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteFile:(NSString *)filePath;

/**
 *  移动文件
 *
 *  @param filePath 文件路径
 *  @param toPath   移动路径
 *
 *  @return 是否移动成功
 */
+ (BOOL)moveFile:(NSString *)filePath toPath:(NSString *)toPath;

/**
 *  复制文件
 *
 *  @param filePath 文件路径
 *  @param toPath   复制路径
 *
 *  @return 是否复制成功
 */
+ (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)toPath;

/**
 *  获取文件大小
 *
 *  @param path 文件路径
 *
 *  @return 文件大小(单位字节)
 */
+ (long long)getFileSize:(NSString *)path;

/**
 *  格式化大小单位
 *
 *  @param value 字节数
 *
 *  @return 格式化大小字符串
 */
+ (NSString *)fileSizeFormat:(long long)value;

/**
 *  判断文件是否存在
 *
 *  @param path 文件路径
 *
 *  @return 是否存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

/**
 *  随机生成文件名 (yyyyMMddHHmmss+4位随机数)
 *
 *  @return 随机名称
 */
+ (NSString *)getRandomFileName;

+(NSString *)savePath:(NSString *)fileName;

+(NSString *)savePath:(NSString *)account wihtFileName:(NSString *)fileName;


@end
