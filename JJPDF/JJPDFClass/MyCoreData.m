//
//  MyCoreData.m
//  zzj
//
//  Created by zzj on 15/7/29.
//  Copyright (c) 2015年 zzj. All rights reserved.
//

#import "MyCoreData.h"

@implementation MyCoreData

- (instancetype)init
{
    return [self initWithDBName:@"MyCoreData.db"];
}

- (instancetype)initWithDBName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        [self _init:dbName];
    }
    return self;
}

- (void)_init:(NSString *)dbName
{
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:dbName]];
    
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    
    // 初始化上下文，设置persistentStoreCoordinator属性
    _context = [[NSManagedObjectContext alloc] init];
    _context.persistentStoreCoordinator = psc;
}

#pragma mark - save

- (NSError *)save
{
    NSError *error = nil;
    BOOL success = [self.context save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
    return error;
}

#pragma mark - insert

- (id)insertNewObject:(NSString *)cls
{
    // 传入上下文，创建一个Person实体对象
    return [NSEntityDescription insertNewObjectForEntityForName:cls inManagedObjectContext:self.context];
}

#pragma mark - select

- (NSArray *)selectObject:(NSString *)cls
{
    return [self selectObject:cls condition:nil sortingType:MYCD_NIL forKey:nil];
}

- (NSArray *)selectObject:(NSString *)cls sortingType:(MYCD_SORTINGTYPE)sortingType forKey:(NSString *)key
{
    return [self selectObject:cls condition:nil sortingType:sortingType forKey:key];
}

- (NSArray *)selectObject:(NSString *)cls condition:(NSPredicate *)condition
{
    return [self selectObject:cls condition:condition sortingType:MYCD_NIL forKey:nil];
}

- (NSArray *)selectObject:(NSString *)cls condition:(NSPredicate *)condition sortingType:(MYCD_SORTINGTYPE)sortingType forKey:(NSString *)key
{
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:cls inManagedObjectContext:self.context];
    
    NSArray *sortInfo = nil;
    if (sortingType == MYCD_ASC && key)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
        sortInfo = @[sort];
    }
    else if (sortingType == MYCD_DESC && key)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:NO];
        sortInfo = @[sort];
    }
    
    // 排序方式
    request.sortDescriptors = sortInfo;
    
    if (condition)
    {
        // 设置条件过滤
        request.predicate = condition;
    }

    // 执行请求
    NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    
    return objs;
}

#pragma mark - delete

- (void)deleteObject:(NSManagedObject *)obj
{
    [self.context deleteObject:obj];
}

- (void)deleteObjects:(NSArray *)objects
{
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [self.context deleteObject:obj];
    }];
}


@end





