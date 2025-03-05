//
//  beforeModel.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/29.
//

#import "BeforeModel.h"
#import "BeforeSubModel.h"

@implementation BeforeModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"stories":[BeforeSubModel class]};
}

@end
