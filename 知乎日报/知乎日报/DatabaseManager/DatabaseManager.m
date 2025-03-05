//
//  DatabaseManager.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/14.
//

#import "DatabaseManager.h"

static DatabaseManager *managerSington = nil;

@implementation DatabaseManager

+ (instancetype)shareManeger {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            managerSington = [[super allocWithZone:NULL] init];
        });
    return managerSington;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [DatabaseManager shareManeger];
}

- (void)databaseInit {
    NSString *likeDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *likesFileName = [likeDoc stringByAppendingPathComponent:@"likesData.sqlite"];
    self.likesDatabase = [FMDatabase databaseWithPath:likesFileName];
    if ([self.likesDatabase open]) {
        BOOL result = [self.likesDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS likesData (id text NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    }
    NSString *collectionDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *collectionFileName = [collectionDoc stringByAppendingPathComponent:@"collectionData.sqlite"];
    self.collectionDatabase = [FMDatabase databaseWithPath:collectionFileName];
    if ([self.collectionDatabase open]) {
        BOOL result = [self.collectionDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS collectionData (id text NOT NULL, title text NOT NULL, image text NOT NULL, URL text NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    }
}

- (void)insertCollectionDatabaseWithId:(NSString*)idString andTile:(NSString*)title andImage:(NSString*)image andURL:(NSString*)URL {
    if ([self.collectionDatabase open]) {
        BOOL result = [self.collectionDatabase executeUpdate:@"INSERT INTO collectionData (id, title, image, URL) VALUES (?, ?, ?, ?);", idString, title, image, URL];
        if (!result) {
            NSLog(@"增加收藏数据失败");
        } else {
            NSLog(@"增加收藏数据成功");
        }
    }
    [self.collectionDatabase close];
}

- (void)deleteCollectionData:(NSString*)idString {
    if ([self.collectionDatabase open]) {
        NSString *sql = @"delete from collectionData WHERE id = ?";
        BOOL result = [self.collectionDatabase executeUpdate:sql, idString];
        if (!result) {
            NSLog(@"删除收藏数据失败");
        } else {
            NSLog(@"删除收藏数据成功");
        }
    }
    [self.collectionDatabase close];
}

- (void)insertLikeDatabase:(NSString*)idString {
    if ([self.likesDatabase open]) {
        BOOL result = [self.likesDatabase executeUpdate:@"INSERT INTO likesData (id) VALUES (?)", idString];
        NSLog(@"%d",result);
        if (!result) {
            NSLog(@"增加点赞数据失败");
        } else {
            NSLog(@"增加点赞数据成功");
        }
    }
    [self.likesDatabase close];
}

- (void)deleteLikeData:(NSString*)idString {
    if ([self.likesDatabase open]) {
        NSString *sql = @"delete from likesData WHERE id = ?";
        BOOL result = [self.likesDatabase executeUpdate:sql, idString];
        if (!result) {
            NSLog(@"删除点赞数据失败");
        } else {
            NSLog(@"删除点赞数据成功");
        }
    }
    [self.collectionDatabase close];
}

- (BOOL)queryCollectionData:(NSString*)idString {
    if ([self.collectionDatabase open]) {
        FMResultSet* collectionResultSet = [self.collectionDatabase executeQuery:@"SELECT * FROM collectionData"];
        while ([collectionResultSet next]) {
            NSString *sqlIdStr = [NSString stringWithFormat:@"%@", [collectionResultSet objectForColumn:@"id"]];
            NSLog(@"%@ aaa %@", sqlIdStr, idString);
            if ([idString isEqualToString:sqlIdStr]) {
                [self.collectionDatabase close];
                return TRUE;
            }
        }
    }
    [self.collectionDatabase close];
    return FALSE;
}

- (BOOL)queryLikeData:(NSString*)idString {
    if ([self.likesDatabase open]) {
        FMResultSet* likesResultSet = [self.likesDatabase executeQuery:@"SELECT * FROM likesData"];
        while ([likesResultSet next]) {
            NSString *sqlIdStr = [NSString stringWithFormat:@"%@", [likesResultSet objectForColumn:@"id"]];
            NSLog(@"%@ aaa %@", sqlIdStr, idString);
            if ([idString isEqualToString:sqlIdStr]) {
                [self.likesDatabase close];
                return TRUE;
            }
        }
    }
    [self.likesDatabase close];
    return FALSE;
}

- (void)queryCollectionDataWithCompeletion:(void (^)(NSMutableArray *CollectionArray, NSError *error))completion {
    if ([self.collectionDatabase open]) {
        NSMutableArray* tempCollectionArray = [[NSMutableArray alloc] init];
        FMResultSet *resultSet = [self.collectionDatabase executeQuery:@"SELECT * FROM collectionData"];
        while ([resultSet next]) {
            NSDictionary* ArticleOfCollection = [[NSMutableDictionary alloc] init];
            NSString* idString = [resultSet stringForColumn:@"id"];
            NSString* title = [resultSet stringForColumn:@"title"];
            NSString* image = [resultSet stringForColumn:@"image"];
            NSString* URL = [resultSet stringForColumn:@"URL"];
            [ArticleOfCollection setValue:idString forKey:@"id"];
            [ArticleOfCollection setValue:title forKey:@"title"];
            [ArticleOfCollection setValue:image forKey:@"image"];
            [ArticleOfCollection setValue:URL forKey:@"URL"];
            [tempCollectionArray addObject:ArticleOfCollection];
        }
        completion(tempCollectionArray, nil);
    }
}

@end
