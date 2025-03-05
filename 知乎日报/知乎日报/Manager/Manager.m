//
//  Manager.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/22.
//

#import "Manager.h"
#import "AFNetworking.h"

@implementation Manager

static Manager *managerSington = nil;

+ (instancetype)shareManeger {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            managerSington = [[super allocWithZone:NULL] init];
        });
    return managerSington;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [Manager shareManeger];
}

- (void)NetWorkGetWithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"https://news-at.zhihu.com/api/4/news/latest";
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion((NSDictionary *)responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@", error);
    }];
}

- (void)NetWorkGetBefore:(NSString*)date WithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"https://news-at.zhihu.com/api/4/news/before/";
    url = [url stringByAppendingString:date];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion((NSDictionary *)responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@", error);
    }];
}

- (void)NetWorkGetFor:(NSString*)idString WithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* url = @"https://news-at.zhihu.com/api/4/story-extra/";
    url = [url stringByAppendingFormat:@"%@",idString];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion((NSDictionary *)responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@", error);
    }];
}

- (void)NetWorkGetLongComentsFor:(NSString*)idString WithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story/%@/long-comments",idString];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion((NSDictionary *)responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@", error);
    }];
}

- (void)NetWorkGetShortComentsFor:(NSString*)idString WithCompletion:(void (^)(NSDictionary *userData, NSError *error))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story/%@/short-comments",idString];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion((NSDictionary *)responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@", error);
    }];
}

@end
