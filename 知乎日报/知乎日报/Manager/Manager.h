//
//  Manager.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Manager : NSObject

+ (instancetype)shareManeger;
- (void)NetWorkGetWithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion;
- (void)NetWorkGetBefore:(NSString*)date WithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion;
- (void)NetWorkGetFor:(NSString*)idString WithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion;
- (void)NetWorkGetLongComentsFor:(NSString*)idString WithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion;
- (void)NetWorkGetShortComentsFor:(NSString*)idString WithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
