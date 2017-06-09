
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "TDEntity.h"

@interface TDEntity ()
@property (nonatomic, strong) TDDbHelper *db;
@end

@implementation TDEntity

singleton_implementation(TDEntity)

#pragma mark - 公开方法
#pragma mark 保存数据
- (BOOL)saveWithClass:(Class)tableClass model:(id)model
{
    // 表不存在则自动创建
    if (![self.db isExistTableWithModelClass:tableClass]) {
      if([self autoCreateTable:tableClass])
      {
          NSLog(@"创建表成功");
      }
    }
    
    // Model转字典并保存入库
    NSDictionary *dict = [tableClass dictionaryWithModel:model];
    BOOL b = [self.db insertWithTableName:tableClass valueMap:dict];
    
    //NSLog(@"[数据库]保存文件列表成功:%zd",b);
    
    return b;
}

#pragma mark 删除数据
- (BOOL)deleteWithClass:(Class)tableClass condition:(NSDictionary *)conditionMap
{
    BOOL b = YES;
    // 1.判断数据表是否存在
    if ([self.db isExistTableWithModelClass:tableClass]) {
        // 2.删除数据
        b =  [self.db deleteWithTableName:tableClass conditionMap:conditionMap];
    }
    return b;
}

#pragma mark 清空数据表
- (BOOL)truncateWithClass:(Class)tableClass
{
    BOOL b = YES;
    // 1.判断数据表是否存在
    if ([self.db isExistTableWithModelClass:tableClass]) {
        // 2.清空数据
        b =  [self.db truncateWithTableName:tableClass];
    }
    return b;
}

#pragma mark 修改数据
- (BOOL)updateWithClass:(Class)tableClass value:(NSDictionary *)valueMap condition:(NSDictionary *)conditionMap
{
    BOOL b = NO;
    // 1.判断数据表是否存在
    if ([self.db isExistTableWithModelClass:tableClass]) {
        // 2.修改数据
        b = [self.db updateWithTableName:tableClass valueMap:valueMap conditionMap:conditionMap];
    }
    return b;
}

#pragma mark 查询数据
- (NSMutableArray *)queryWithClass:(Class)tableClass condition:(NSDictionary *)conditionMap sqlOrder:(NSString *)sqlOrder
{
    NSMutableArray *models = [NSMutableArray array];
    
    // 1.判断数据表是否存在
    if ([self.db isExistTableWithModelClass:tableClass]) {
        // 2.查询数据表
        NSMutableArray *dbArray = [self.db queryWithTableName:tableClass
                                                     columnList:nil conditionMap:conditionMap sqlOrder:sqlOrder];
        if ([dbArray count] > 0) {
            for (NSDictionary *dict in dbArray) {
                id model = [tableClass modelWithDictionary:dict];
                [models addObject:model];
            }
        }
    }
    return models;
}

- (NSMutableArray *)queryWithClass:(Class)tableClass columnList:(NSArray *)columnList condition:(NSDictionary *)conditionMap sqlOrder:(NSString *)sqlOrder
{
    NSMutableArray *dbArray = [NSMutableArray array];
    
    // 1.判断数据表是否存在
    if ([self.db isExistTableWithModelClass:tableClass]) {
        // 2.查询数据表
       dbArray = [self.db queryWithTableName:tableClass
                                                   columnList:columnList conditionMap:conditionMap sqlOrder:sqlOrder];
    }
    return dbArray;
}

#pragma mark 关闭数据库
- (void)close
{
    [_db close];
    self.db = nil;
}

#pragma mark - 辅助方法
#pragma mark 操作数据库实例
- (TDDbHelper *)db
{
    if (nil == _db) {
        NSString * path = [FileHelper savePath:TD_USER_DBNAME];
        TDDbHelper *dbHelper = [[TDDbHelper alloc] initDBWithPath:path];
        _db = dbHelper;
    }
    return _db;
}

#pragma mark 判断表是否存在
- (BOOL)isExistTable:(Class)tableClass
{
    return [self.db isExistTableWithModelClass:tableClass];
}

#pragma mark 自动创建表
- (BOOL)autoCreateTable:(Class)tableClass
{
    NSString *primaryKey = nil;
    NSString *className = NSStringFromClass(tableClass);
    if ([className containsString:@"TDFileModel"]) {
        primaryKey = @"appFileId";
    }
    return [self.db createTableWithModelClass:tableClass primaryKey:primaryKey];
}

@end
