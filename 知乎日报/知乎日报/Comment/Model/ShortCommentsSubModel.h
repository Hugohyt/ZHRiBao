//
//  ShortCommentsSubModel.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShortCommentsSubModel : NSObject

@property NSString* author;
@property NSString* content;
@property NSString* avatar;
@property NSString* time;
@property NSDictionary* reply_to;
@property NSString* likes;

@property CGFloat titleActualH;
@property CGFloat titleMaxH;
@property BOOL isOpen;

- (void)calculate:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
