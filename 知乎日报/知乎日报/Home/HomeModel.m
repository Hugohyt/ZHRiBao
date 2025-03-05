//
//  homeModel.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/22.
//

#import "HomeModel.h"
#import "SubModel.h"
#import "TopSubModel.h"

@implementation HomeModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"stories":[SubModel class],
             @"top_stories":[TopSubModel class]};
}

@end
