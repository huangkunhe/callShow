
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "TDDbHelper.h"
#import "SCSDKHeader.h"

/**
 *  面向对象操作数据库(SDK所有数据库操作都使用此类)
 */
@interface TDEntity : NSObject

singleton_interface(TDEntity)

- (BOOL)saveWithClass:(Class)tableClass model:(id)model;
- (BOOL)deleteWithClass:(Class)tableClass condition:(NSDictionary *)conditionMap;
- (BOOL)truncateWithClass:(Class)tableClass;
- (BOOL)updateWithClass:(Class)tableClass value:(NSDictionary *)valueMap condition:(NSDictionary *)conditionMap;
- (NSMutableArray *)queryWithClass:(Class)tableClass condition:(NSDictionary *)conditionMap sqlOrder:(NSString *)sqlOrder;
- (NSMutableArray *)queryWithClass:(Class)tableClass columnList:(NSArray *)columnList condition:(NSDictionary *)conditionMap sqlOrder:(NSString *)sqlOrder;

/**
 *  关闭数据库(用户登出调用此方法)
 */
- (void)close;

@end
