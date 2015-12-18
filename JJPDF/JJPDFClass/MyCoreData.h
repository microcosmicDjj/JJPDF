//
//  MyCoreData.h
//  zzj
//
//  Created by zzj on 15/7/29.
//  Copyright (c) 2015年 zzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {

    MYCD_NIL,
    MYCD_ASC,
    MYCD_DESC
    
} MYCD_SORTINGTYPE;

@interface MyCoreData : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

- (instancetype)initWithDBName:(NSString *)dbName;

- (NSError *)save;

- (id)insertNewObject:(NSString *)cls;

- (NSArray *)selectObject:(NSString *)cls;
- (NSArray *)selectObject:(NSString *)cls sortingType:(MYCD_SORTINGTYPE)sortingType forKey:(NSString *)key;
- (NSArray *)selectObject:(NSString *)cls condition:(NSPredicate *)condition;
- (NSArray *)selectObject:(NSString *)cls condition:(NSPredicate *)condition sortingType:(MYCD_SORTINGTYPE)sortingType forKey:(NSString *)key;

- (void)deleteObject:(NSManagedObject *)obj;
- (void)deleteObjects:(NSArray *)objects;

@end
