//
//  homeView.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/22.
//

#import "HomeView.h"
#import "Masonry.h"
#import "ScrollerCell.h"
#import "ArticleCell.h"
#import "SDWebImage.h"
#import "SubModel.h"
#import "YYModel.h"

@implementation HomeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    self.imageView1 = [[UIImageView alloc] init];
    self.imageView1.backgroundColor = [UIColor whiteColor];
    self.imageView1.userInteractionEnabled = YES;
    [self addSubview:self.imageView1];
    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(394);
        make.height.mas_equalTo(110);
    }];
    self.imageView1.frame = CGRectMake(0, 0, 394, 110);
    
    UIImageView* verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(70, 50, 1, 40)];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:verticalLine];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.frame = CGRectMake(20, 50, 40, 20);
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.frame = CGRectMake(10, 70, 60, 20);
    dayLabel.text = [NSString stringWithFormat:@"%lu",component.day];
    monthLabel.text = [self getMonth:component.month];
    [dayLabel setFont:[UIFont systemFontOfSize:24]];
    [monthLabel setFont:[UIFont systemFontOfSize:16]];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.imageView1 addSubview:dayLabel];
    [self.imageView1 addSubview:monthLabel];
    
    self.icon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.icon.frame = CGRectMake(330, 44, 50, 50);
    self.icon.layer.cornerRadius = 30;
    self.icon.layer.masksToBounds = YES;
    [self.icon setImage:[UIImage imageNamed:@"头像.jpg"] forState:UIControlStateNormal];
    [self.imageView1 addSubview:self.icon];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 97, 394, 760) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[ScrollerCell class] forCellReuseIdentifier:@"ScrollerCell"];
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:@"ArticleCell"];
    self.tableView.allowsSelection = YES;
    [self addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(110);
//        make.left.equalTo(self);
//        make.width.mas_equalTo(394);
//        make.height.mas_equalTo(760);
//    }];
    
    self.footer = [[UIView alloc] init];
    self.footer.frame = CGRectMake(0, self.tableView.bounds.size.height + 50, 394, 50);
    self.footer.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:self.footer];
    
    self.footerLabel = [[UILabel alloc] init];
    self.footerLabel.frame = self.footer.bounds;
    [self.footerLabel setText:@"下拉可以刷新"];
    [self.footerLabel setFont:[UIFont systemFontOfSize:16]];
    [self.footerLabel setTextColor:[UIColor grayColor]];
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    [self.footer addSubview:self.footerLabel];
    
    return self;
}

- (NSString*)getMonth: (NSInteger)month {
    if (month == 1) {
        return @"一月";
    } else if (month == 2) {
        return @"二月";
    } else if (month == 3) {
        return @"三月";
    } else if (month == 4) {
        return @"四月";
    } else if (month == 5) {
        return @"五月";
    } else if (month == 6) {
        return @"六月";
    } else if (month == 7) {
        return @"七月";
    } else if (month == 8) {
        return @"八月";
    } else if (month == 9) {
        return @"九月";
    } else if (month == 10) {
        return @"十月";
    } else if (month == 11) {
        return @"十一月";
    } else if (month == 12) {
        return @"十二月";
    }
    return nil;
}

@end
