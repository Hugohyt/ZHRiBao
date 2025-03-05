//
//  homeModel.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/22.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject <YYModel>

@property NSString* date;
@property NSArray* stories;
@property NSArray* top_stories;

@end

NS_ASSUME_NONNULL_END
