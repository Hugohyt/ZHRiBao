//
//  CollectionTableView.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import "CollectionTableView.h"
#import "CollectionArtcleCell.h"
#import "SDWebImage.h"

@interface CollectionTableView ()

@end

@implementation CollectionTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.headTabView = [[UIImageView alloc] init];
    self.headTabView.frame = CGRectMake(0, 0, 393, 110);
    self.headTabView.userInteractionEnabled = YES;
    [self.headTabView setBackgroundColor:[UIColor whiteColor]];
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitButton setImage:[UIImage imageNamed:@"返回.jpg"] forState:UIControlStateNormal];
    self.titleLabel = [[UILabel alloc] init];
    self.exitButton.frame = CGRectMake(0, 64, 30, 30);
    self.titleLabel.frame = CGRectMake(146, 60, 100, 40);
    self.titleLabel.text = @"收藏";
    [self.titleLabel setFont:[UIFont systemFontOfSize:24]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headTabView addSubview:self.exitButton];
    [self.headTabView addSubview:self.titleLabel];
    [self addSubview:self.headTabView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 110, 393, 800);
    [self addSubview:self.tableView];
    [self.tableView registerClass:[CollectionArtcleCell class] forCellReuseIdentifier:@"CollectionArtcleCell"];
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
