//
//  DatabaseManager.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/14.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

@property FMDatabase* likesDatabase;
@property FMDatabase* collectionDatabase;

+ (instancetype)shareManeger;
- (void)databaseInit;
- (void)insertCollectionDatabaseWithId:(NSString*)idString andTile:(NSString*)title andImage:(NSString*)image andURL:(NSString*)URL;
- (void)deleteCollectionData:(NSString*)idString;
- (void)insertLikeDatabase:(NSString*)idString;
- (void)deleteLikeData:(NSString*)idString;
- (BOOL)queryCollectionData:(NSString*)idString;
- (BOOL)queryLikeData:(NSString*)idString;
- (void)queryCollectionDataWithCompeletion:(void (^)(NSMutableArray *CollectionArray, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
