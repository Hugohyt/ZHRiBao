//
//  ShortCommentsModel.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/5.
//

#import "ShortCommentsModel.h"
#import "ShortCommentsSubModel.h"

@implementation ShortCommentsModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"comments":[ShortCommentsSubModel class]};
}

@end
