//
//  NSDictionary+LinqExtensions.m
//  LinqToObjectiveC
//
//  Created by Colin Eberhardt on 25/02/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NSDictionary+LinqExtensions.h"

@implementation NSDictionary (QueryExtension)

#pragma mark - ⊂((・猿・))⊃ 查
#pragma mark - where

- (NSDictionary *)linq_where:(LINQKeyValueCondition)predicate {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (predicate(key, obj)) {
            result[key] = obj;
        }
    }];
    return result;
}

- (NSUInteger)linq_count:(LINQKeyValueCondition)condition {
    return [self linq_where:condition].count;
}

#pragma mark -

- (BOOL)linq_all:(LINQKeyValueCondition)condition {
    __block BOOL all = TRUE;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!condition(key, obj)) {
            all = FALSE;
            *stop = TRUE;
        }
    }];
    return all;
}

- (BOOL)linq_any:(LINQKeyValueCondition)condition {
    __block BOOL any = FALSE;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (condition(key, obj)) {
            any = TRUE;
            *stop = TRUE;
        }
    }];
    return any;
}

#pragma mark - ⊂((・猿・))⊃ 改
#pragma mark - select

- (NSDictionary *)linq_select:(LINQKeyValueSelector)selector {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = selector(key, obj);
        if (!object)
            object = [NSNull null];

        result[key] = object;
    }];
    return result;
}

#pragma mark - toArray（转换成数组）

- (NSArray *)linq_toArray:(LINQKeyValueSelector)selector {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = selector(key, obj);
        if (!object)
            object = [NSNull null];
        [result addObject:object];
    }];
    return result;
}

#pragma mark - Merge(合并)

- (NSDictionary *)linq_Merge:(NSDictionary *)dictionary {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:self];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!result[key]) {
            result[key] = obj;
        }
    }];
    return result;
}

@end
