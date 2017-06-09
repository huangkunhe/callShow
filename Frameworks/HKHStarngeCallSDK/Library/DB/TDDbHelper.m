
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "TDDbHelper.h"
#import "TD_FMDatabase.h"
#import "TD_FMDatabaseQueue.h"

#import "NSObject+TD.h"
#import "NSString+SC.h"

// 把OC类型转换为SQLite类型
extern inline NSString* TDSQLTypeFromObjcType(NSString *objcType);

// 字段相关
static NSString* const TDSQLText        =   @"text";
static NSString* const TDSQLInt         =   @"integer";
static NSString* const TDSQLDouble      =   @"double";
static NSString* const TDSQLBlob        =   @"blob";

static NSString* const TDSQLNotNull     =   @"NOT NULL";
static NSString* const TDSQLPrimaryKey  =   @"PRIMARY KEY";
static NSString* const TDSQLDefault     =   @"DEFAULT";
static NSString* const TDSQLUnique      =   @"UNIQUE";
static NSString* const TDSQLCheck       =   @"CHECK";
static NSString* const TDSQLForeignKey  =   @"FOREIGN KEY";

static NSString* const TDSQLFloatType   =   @"float_double_decimal";
static NSString* const TDSQLIntType     =   @"int_char_short_long_NSNumber";
static NSString* const TDSQLBlobType    =   @"";

static NSString* const TDSQLInherit          =   @"KLDBInherit";
static NSString* const TDSQLBinding          =   @"KLDBBinding";
static NSString* const TDSQLUserCalculate    =   @"KLDBUserCalculate";

////////////////////////////////////////////////////////////////

@interface TDDbHelper ()

// 操作数据库实例
@property (nonatomic, strong) TD_FMDatabaseQueue *dbQueue;

// 创建SQL语句函数
NSString *createSelectSQL(NSString *tablename, NSArray *column_list, NSDictionary *condition_map);
NSString *createUpdateSQL(NSString *tablename, NSDictionary *value_map, NSDictionary *condition_map);
NSString *createInsertSQL(NSString *tablename, NSDictionary *value_map);
NSString *createDeleteSQL(NSString *tablename, NSDictionary *condition_map);

@end

@implementation TDDbHelper

#pragma mark - 初始化方法
- (id)initDBWithPath:(NSString *)path
{
    if (![path isValid]) {
        NSLog(@"[数据库]路径不合法:%@",path);
        self = nil;
    }
    else {
        self = [super init];
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [TD_FMDatabaseQueue databaseQueueWithPath:path];
        //NSLog(@"[数据库]路径:%@",path);
    }
    return self;
}

- (id)initDBWithName:(NSString *)dbName
{
    if (![dbName isValid]) {
        NSLog(@"[数据库]名称不合法:%@",dbName);
        self = nil;
    }
    else {
        self = [super init];
        NSString * dbPath = [NSTemporaryDirectory() stringByAppendingPathComponent:dbName];
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [TD_FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (void)close
{
    [_dbQueue close];
    _dbQueue = nil;
}

#pragma mark - 增删改查
- (BOOL)insertWithTableName:(Class)tableClass valueMap:(NSDictionary *)valueMap
{
    NSString *tableName = getTableName(tableClass);
    NSString *sql = createInsertSQL(tableName, valueMap);
    return [self execUpdate:sql];
}

- (BOOL)deleteWithTableName:(Class)tableClass conditionMap:(NSDictionary *)conditionMap
{
    NSString *tableName = getTableName(tableClass);
    NSString *sql = createDeleteSQL(tableName, conditionMap);
    return [self execUpdate:sql];
}

- (BOOL)truncateWithTableName:(Class)tableClass
{
    NSString *tableName = getTableName(tableClass);
    NSString *sql = [NSString stringWithFormat:@"TRUNCATE TABLE %@",tableName];
    return [self execUpdate:sql];
}

- (BOOL)updateWithTableName:(Class)tableClass valueMap:(NSDictionary *)valueMap conditionMap:(NSDictionary *)conditionMap
{
    NSString *tableName = getTableName(tableClass);
    NSString *sql = createUpdateSQL(tableName, valueMap, conditionMap);
    return [self execUpdate:sql];
}

- (NSMutableArray *)queryWithTableName:(Class)tableClass columnList:(NSArray *)columnList conditionMap:(NSDictionary *)conditionMap sqlOrder:(NSString *)sqlOrder
{
    NSString *tableName = getTableName(tableClass);
    NSString *sql = createSelectSQL(tableName, columnList, conditionMap);
    if (sqlOrder) {
        sql = [NSString stringWithFormat:@"%@ %@",sql,sqlOrder];
    }
    return [self execQuery:sql];
}

- (BOOL)execQueryWithSql:(NSString *)sql
{
    return [self execUpdate:sql];
}

#pragma mark - 创建数据表
inline NSString *TDSQLTypeFromObjcType(NSString *objcType)
{
    if([TDSQLIntType rangeOfString:objcType].location != NSNotFound) {
        return TDSQLInt;
    }
    if ([TDSQLFloatType rangeOfString:objcType].location != NSNotFound) {
        return TDSQLDouble;
    }
    if ([TDSQLBlobType rangeOfString:objcType].location != NSNotFound) {
        return TDSQLBlob;
    }
    
    return TDSQLText;
}

NSString *getTableName(Class modelClass)
{
    // 修改数据表名称
    // TDFileModel -> td_file
    return [[[NSStringFromClass(modelClass) lowercaseString] replaceCharcter:@"td" withCharcter:@"td_"] replaceCharcter:@"model" withCharcter:@""];
}

- (BOOL)isExistTable:(NSString *)tableName
{
    __block BOOL result = NO;
    [_dbQueue inDatabase:^(TD_FMDatabase *db) {
        TD_FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?",tableName];
        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"count"];
            if (0 != count) {
                result = YES;
            }
        }
    }];
    return result;
}

- (BOOL)isExistTableWithModelClass:(Class)modelClass
{
    NSString *tableName = getTableName(modelClass);
    return [self isExistTable:tableName];
}

- (BOOL)createTableWithModelClass:(Class)modelClass primaryKey:(NSString *)primaryKey
{
    // 已创建直接返回成功
    NSString *tableName = getTableName(modelClass);
    BOOL isExist = [self isExistTable:tableName];
    if (isExist) {
        return YES;
    }
    
    // 根据数据模型获取字段和类型
    NSMutableArray *pronames = [NSMutableArray array];
    NSMutableArray *protypes = [NSMutableArray array];
    [modelClass getSelfPropertys:pronames protypes:protypes];
    
    NSString *sqlColumeName, *sqlColumeType;
    NSMutableString *table_pars = [NSMutableString string];
    
    // 主关键字
    BOOL hasPrimaryKey = NO;
    if ([primaryKey isValid]) {
        hasPrimaryKey = YES;
    }
    
    for (int i=0; i<pronames.count; i++)
    {
        if(i > 0) [table_pars appendString:@","];
        
        sqlColumeName = pronames[i];
        sqlColumeType = TDSQLTypeFromObjcType(protypes[i]);
        
        // 设置字段和类型
        [table_pars appendFormat:@"%@ %@",sqlColumeName,sqlColumeType];
        // 设置字段不为空
        //[table_pars appendFormat:@" %@",TDSQLNotNull];
        // 设置主关键字
        if (hasPrimaryKey && [sqlColumeName isEqualToString:primaryKey]) {
            [table_pars appendFormat:@" %@",TDSQLPrimaryKey];
        }
    }
    
    // 创建数据表SQL语句
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",tableName,table_pars];
    return [self execUpdate:createTableSQL];
}

#pragma mark - 私有方法
#pragma mark 更新数据表(增删改)
- (BOOL)execUpdate:(NSString *)sql
{
    __block BOOL result = NO;
    [_dbQueue inDatabase:^(TD_FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        NSLog(@"[数据库]更新数据表失败");
    } else {
        //NSLog(@"[数据库]更新数据表成功:%@",sql);
    }
    return result;
}

#pragma mark 查询数据表
- (NSMutableArray *)execQuery:(NSString *)sql
{
    NSMutableArray *result = [NSMutableArray array];
    [_dbQueue inDatabase:^(TD_FMDatabase *db) {
        TD_FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:0];
            for (int i=0; i<[rs columnCount]; i++) {
                NSString *key = [rs columnNameForIndex:i];
                NSString *value = [rs stringForColumn:key];
                if (![value isValid]) {
                    value = @"";
                }
                [data setObject:value forKey:key];
            }
            [result addObject:data];
        }
    }];
    //NSLog(@"[数据库]查询数据表SQL:%@",sql);
    return result;
}

#pragma mark - 私有函数
#pragma mark 判读是否有SQL条件符号
BOOL containsSqlConditionSymbol(NSString *value)
{
    BOOL b = NO;
    NSString *keyword = [value lowercaseString];
    for (NSString *symbol in @[@"=", @"!=", @">", @">=", @"<", @"<=", @"like"]) {
        if ([keyword containsString:symbol]) {
            b = YES;
            break;
        }
    }
    return b;
}

#pragma mark 过滤特殊字符
NSString *stripslashes(NSString *value)
{
     return [value replaceCharcter:@"\"" withCharcter:@""];
//     return [[value replaceCharcter:@"'" withCharcter:@""] replaceCharcter:@"\"" withCharcter:@""];
}

#pragma mark 创建查询SQL语句
NSString *createSelectSQL(NSString *tablename, NSArray *column_list, NSDictionary *condition_map)
{
    if (tablename == nil) {
        return nil;
    }
    NSString *sqlString = @"SELECT";
    NSString *fields = @"";
    
    if (column_list == nil || [column_list count]<1) {
        fields = @" * ";
    }
    else {
        for (int i = 0; i<[column_list count]; i++) {
            NSString *seperator = [fields length]<1?@" ":@",";
            fields = [[fields stringByAppendingString:seperator] stringByAppendingString:[column_list objectAtIndex:i]];
        }
        fields = [fields stringByAppendingString:@" "];
    }
    
    sqlString = [sqlString stringByAppendingString:fields];
    sqlString = [sqlString stringByAppendingString:@"FROM "];
    sqlString = [sqlString stringByAppendingString:tablename];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    
    // 条件语句
    NSString *conditions = @"";
    sqlString = [sqlString stringByAppendingString:@" WHERE "];
    
    NSArray *conditionKeys = [condition_map allKeys];
    for (int j =0; j < [conditionKeys count]; j++)
    {
        NSString *key = [conditionKeys objectAtIndex:j];
        NSString *value = [condition_map objectForKey:key];
        if ([[condition_map objectForKey:key] isKindOfClass:[NSNumber class]]) {
            value = [[[NSNumberFormatter alloc] init] stringFromNumber:[condition_map objectForKey:key]];
        }
        
        // 过滤
        if (![value isValid]) {
            continue;
        } else {
            value = [NSString stringWithFormat:@"'%@'",stripslashes(value)];
        }
        
        NSString *seperator = [conditions length]<1?@"":@" AND ";
        
        NSString *symbol = containsSqlConditionSymbol(key)?key:[NSString stringWithFormat:@"%@=",key];
        conditions = [[[conditions stringByAppendingString:seperator] stringByAppendingString:symbol] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    
    return sqlString;
}

#pragma mark 创建更新SQL语句
NSString *createUpdateSQL(NSString *tablename, NSDictionary *value_map, NSDictionary *condition_map)
{
    if (tablename == nil || value_map == nil) {
        return nil;
    }
    NSString *updateFields = @"";
    NSString *sqlString = @"UPDATE ";
    sqlString = [sqlString stringByAppendingString:tablename];
    sqlString = [sqlString stringByAppendingString:@" SET"];
    
    NSArray *allKeys = [value_map allKeys];
    for (int i = 0; i<[allKeys count]; i++)
    {
        NSString *seperator = [updateFields length]<1?@" ":@",";
        NSString *key = [allKeys objectAtIndex:i];
        NSString *value = [NSString stringWithFormat:@"%@",[value_map objectForKey:key]];
        value = [NSString stringWithFormat:@"\"%@\"",value];
        // 字符串转换并过滤“<null>”
        if ([value containsString:@"<null>"]) {
            value = @"";
        } else {
            value = [NSString stringWithFormat:@"'%@'",stripslashes(value)];
        }
        
        updateFields = [[[[updateFields stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:updateFields];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    
    // 条件语句
    NSString *conditions = @"";
    sqlString = [sqlString stringByAppendingString:@" WHERE "];

    NSArray *conditionKeys = [condition_map allKeys];
    for (int j =0; j < [conditionKeys count]; j++)
    {
        NSString *key = [conditionKeys objectAtIndex:j];
        NSString *value = [condition_map objectForKey:key];
        if ([[condition_map objectForKey:key] isKindOfClass:[NSNumber class]]) {
            value = [[[NSNumberFormatter alloc] init] stringFromNumber:[condition_map objectForKey:key]];
        }
        // 过滤
        if (![value isValid]) {
            continue;
        } else {
             value = [NSString stringWithFormat:@"'%@'",stripslashes(value)];
        }
        
        NSString *seperator = [conditions length]<1?@"":@" AND ";
        
        NSString *symbol = containsSqlConditionSymbol(key)?key:[NSString stringWithFormat:@"%@=",key];
        conditions = [[[conditions stringByAppendingString:seperator] stringByAppendingString:symbol] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    
    return sqlString;
}

#pragma mark 创建插入SQL语句
NSString *createInsertSQL(NSString *tablename, NSDictionary *value_map)
{
    if (tablename == nil || value_map == nil) {
        return nil;
    }
    NSString *sqlString = @"REPLACE INTO ";  // INSERT INTO
    sqlString = [sqlString stringByAppendingString:tablename];
    sqlString = [sqlString stringByAppendingString:@" ("];
    
    NSString *keyString = @"";
    NSArray *allKeys = [value_map allKeys];
    for (int i = 0 ; i<[allKeys count]; i++)
    {
        NSString *seperator = [keyString length]<1?@"":@",";
        NSString *key = [allKeys objectAtIndex:i];
        keyString = [[keyString stringByAppendingString:seperator] stringByAppendingString:key];
    }
    
    NSString *valueString = @"";
    sqlString = [sqlString stringByAppendingString:keyString];
    sqlString = [sqlString stringByAppendingString:@") VALUES ("];
    
    for (int j = 0 ; j<[allKeys count]; j++)
    {
        NSString *seperator = [valueString length]<1?@"\"":@",\"";
        NSString *key = [allKeys objectAtIndex:j];
        // 字符串转换并过滤“<null>”
        NSString *value = [NSString stringWithFormat:@"%@",[value_map objectForKey:key]];
        if ([value containsString:@"<null>"]) {
            value = @"";
        } else {
            value = stripslashes(value);
        }
        valueString = [[valueString stringByAppendingString:seperator] stringByAppendingString:value];
        valueString = [valueString stringByAppendingString:@"\""];
    }
    
    sqlString = [sqlString stringByAppendingString:valueString];
    sqlString = [sqlString stringByAppendingString:@")"];
    
    return sqlString;
}

#pragma mark 创建删除SQL语句
NSString *createDeleteSQL(NSString *tablename, NSDictionary *condition_map)
{
    if (tablename == nil) {
        return nil;
    }
    NSString *sqlString = @"DELETE FROM ";
    sqlString = [sqlString stringByAppendingString:tablename];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    
    // 条件语句
    NSString *conditions = @"";
    sqlString = [sqlString stringByAppendingString:@" WHERE "];

    NSArray *conditionKeys = [condition_map allKeys];
    for (int j =0; j < [conditionKeys count]; j++)
    {
        NSString *key = [conditionKeys objectAtIndex:j];
        NSString *value = [condition_map objectForKey:key];
        if ([[condition_map objectForKey:key] isKindOfClass:[NSNumber class]]) {
            value = [[[NSNumberFormatter alloc] init] stringFromNumber:[condition_map objectForKey:key]];
        }
        
        // 过滤
        if (![value isValid]) {
            continue;
        } else {
             value = [NSString stringWithFormat:@"'%@'",stripslashes(value)];
        }
        
        NSString *seperator = [conditions length]<1?@"":@" AND ";
        NSString *symbol = containsSqlConditionSymbol(key)?key:[NSString stringWithFormat:@"%@=",key];
        conditions = [[[conditions stringByAppendingString:seperator] stringByAppendingString:symbol] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    
    return sqlString;
}

@end
