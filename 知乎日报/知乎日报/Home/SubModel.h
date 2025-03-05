//
//  SubModel.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubModel : NSObject

@property NSString* image_hue;
@property NSString* title;
@property NSString* url;
@property NSString* hint;
@property NSString* ga_prefix;
@property NSArray* images;
@property NSString* type;
@property NSString* id;

@end

NS_ASSUME_NONNULL_END
