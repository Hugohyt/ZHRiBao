//
//  CollectionView.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import "CollectionView.h"
#import "IconCell.h"
#import "ItemCell.h"

@implementation CollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.arrayOfCollection = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = self.frame;
    [self addSubview:self.tableView];
    [self.tableView registerClass:[IconCell class] forCellReuseIdentifier:@"IconCell"];
    [self.tableView registerClass:[ItemCell class] forCellReuseIdentifier:@"ItemCell"];
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.exitButton];
    self.exitButton.frame = CGRectMake(20, 50, 30, 30);
    [self.exitButton setImage:[UIImage imageNamed:@"返回.jpg"] forState:UIControlStateNormal];
    
    return self;
}

@end
