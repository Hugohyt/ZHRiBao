//
//  ShortCommentsSubModel.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/5.
//

#import "ShortCommentsSubModel.h"

@implementation ShortCommentsSubModel

- (void)calculate:(NSString *)content {
    NSLog(@"调用了");
    if (content == NULL) {
        self.titleActualH = 0;
        self.titleMaxH = 0;
    } else {
        NSUInteger numCount = 2;
        NSString *str = @"这是一行用来计算高度的文本";
        CGFloat W = 300;
        self.titleActualH = [content boundingRectWithSize:CGSizeMake(W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        self.titleMaxH = [str boundingRectWithSize:CGSizeMake(W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height * numCount;
        NSLog(@"%@ %f %f",content, self.titleActualH, self.titleMaxH);
    }
}

@end
