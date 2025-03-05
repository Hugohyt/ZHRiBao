//
//  CollectionController.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import "CollectionController.h"
#import "CollectionView.h"
#import "IconCell.h"
#import "ItemCell.h"
#import "CollectionViewController.h"

@interface CollectionController ()

@end

@implementation CollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    CollectionView *collectionView = [[CollectionView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:collectionView];
    collectionView.tableView.delegate = self;
    collectionView.tableView.dataSource = self;
    [collectionView.exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 180;
    } else {
        return 50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        IconCell* iconCell = [tableView dequeueReusableCellWithIdentifier:@"IconCell"];
        iconCell.selectionStyle = UITableViewCellSelectionStyleNone;
        iconCell.iconView.image = [UIImage imageNamed:@"头像.jpg"];
        iconCell.nameLabel.text = @"去哪";
        return iconCell;
    } else {
        ItemCell* itemCell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            itemCell.itemLabel.text = @"我的收藏";
        } else {
            itemCell.itemLabel.text = @"消息中心";
        }
        return itemCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        CollectionViewController* collectionViewController = [[CollectionViewController alloc] init];
        collectionViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        collectionViewController.arrayOfCollection = [[NSMutableArray alloc] init];
        collectionViewController.arrayOfCollection = self.arrayOfCollection;
        [self presentViewController:collectionViewController animated:YES completion:nil];
    }
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
