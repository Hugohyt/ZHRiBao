//
//  CommentView.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/5.
//

#import "CommentView.h"
#import "Masonry.h"
#import "CommentCell.h"

@implementation CommentView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 393, 812) style:UITableViewStyleGrouped];
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(393);
        make.height.mas_equalTo(812);
    }];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    
    self.ImageView1 = [[UIImageView alloc] init];
    [self addSubview:self.ImageView1];
    self.ImageView1.userInteractionEnabled = YES;
    [self.ImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(393);
        make.height.mas_equalTo(90);
    }];
    UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 89, 393, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:232.0/255.0 alpha:1]];
    [self.ImageView1 addSubview:line];
    
    self.CommentCount = [[UILabel alloc] init];
    [self.ImageView1 addSubview:self.CommentCount];
    [self.CommentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(46);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    self.CommentCount.font = [UIFont systemFontOfSize:20];
    
    self.ExitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ImageView1 addSubview:self.ExitButton];
    [self.ExitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(46);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self.ExitButton setImage:[UIImage imageNamed:@"返回.jpg"] forState:UIControlStateNormal];
    return self;
}

@end
