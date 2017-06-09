
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------
#import <Foundation/Foundation.h>
/**
 *  数据库管理工具类
 */
@interface TDDbHelper : NSObject

/**
 *  初始化数据库
 *
 *  @param path 数据库路径
 *
 *  @return 操作数据库实例
 */
- (id)initDBWithPath:(NSString *)path;
- (id)initDBWithName:(NSString *)dbName;

/**
 *  关闭数据库
 */
- (void)close;

/**
 *  执行SQL语句
 *
 *  @param sql SQL语句
 *
 *  @return YES成功 NO失败
 */
- (BOOL)execQueryWithSql:(NSString *)sql;

/**
 *  判断表是否已存在
 *
 *  @param modelClass 数据模型
 *
 *  @return YES已存在 NO则否
 */
- (BOOL)isExistTableWithModelClass:(Class)modelClass;

/**
 *  根据数据模型创建对应的数据表
 *
 *  @param tableClass    数据模型
 *  @param primaryKey    主关键字
 *
 *  @return YES创建成功 NO则否
 */
- (BOOL)createTableWithModelClass:(Class)tableClass primaryKey:(NSString *)primaryKey;

/**
 *  插入数据
 *
 *  @param tableClass 数据模型
 *  @param valueMap   插入值字典(自动映射SQL插入值语句)
 *
 *  @return YES成功 NO失败
 */
- (BOOL)insertWithTableName:(Class)tableClass valueMap:(NSDictionary *)valueMap;

/**
 *  删除数据
 *
 *  @param tableClass   数据模型
 *  @param conditionMap 条件字典(自动映射SQL条件语句)
 *
 *  @return YES成功 NO失败
 */
- (BOOL)deleteWithTableName:(Class)tableClass conditionMap:(NSDictionary *)conditionMap;

/**
 *  清空数据表
 *
 *  @param tableClass 数据模型
 *
 *  @return YES成功 NO失败
 */
- (BOOL)truncateWithTableName:(Class)tableClass;

/**
 *  更新数据
 *
 *  @param tableClass   数据模型
 *  @param valueMap     更新值字典(自动映射SQL更新值语句)
 *  @param conditionMap 条件字典(自动映射SQL条件语句)
 *
 *  @return YES成功 NO失败
 */
- (BOOL)updateWithTableName:(Class)tableClass valueMap:(NSDictionary *)valueMap conditionMap:(NSDictionary *)conditionMap;

/**
 *  查询数据
 *
 *  @param tableClass     数据模型
 *  @param columnList     查询字段数组(自动映射SQL查询字段语句)
 *  @param conditionMap   条件字典(自动映射SQL条件语句)
 *  @param sqlOrder       其他条件字符串(e.g. ORDER BY id DESC LIMIT 1)
 *
 *  @return 结果数组
 */
- (NSMutableArray *)queryWithTableName:(Class)tableClass columnList:(NSArray *)columnList conditionMap:(NSDictionary *)conditionMap sqlOrder:(NSString *)sqlOrder;

@end
