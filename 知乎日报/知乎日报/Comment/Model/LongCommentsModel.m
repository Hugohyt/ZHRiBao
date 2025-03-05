//
//  LongCommentsModel.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/5.
//

#import "LongCommentsModel.h"
#import "LongCommentsSubModel.h"

@implementation LongCommentsModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"comments":[LongCommentsSubModel class]};
}


@end
