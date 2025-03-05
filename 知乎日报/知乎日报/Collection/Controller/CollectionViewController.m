//
//  CollectionViewController.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import "CollectionViewController.h"
#import "CollectionTableView.h"
#import "CollectionArtcleCell.h"
#import "SDWebImage.h"
#import "CollectionWebviewController.h"
#import "DatabaseManager.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DatabaseManager *databaseManager = [DatabaseManager shareManeger];
    [databaseManager queryCollectionDataWithCompeletion:^(NSMutableArray *tempArrayOfCollection, NSError *error){
        self.arrayOfCollection = tempArrayOfCollection;
    }];
    self.collectionTableView = [[CollectionTableView alloc] initWithFrame:self.view.frame];
    self.collectionTableView.arrayOfCollection = [[NSMutableArray alloc] init];
    self.collectionTableView.arrayOfCollection = self.arrayOfCollection;
    self.collectionTableView.tableView.delegate = self;
    self.collectionTableView.tableView.dataSource = self;
    [self.collectionTableView.exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.collectionTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    DatabaseManager *databaseManager = [DatabaseManager shareManeger];
    [databaseManager queryCollectionDataWithCompeletion:^(NSMutableArray *tempArrayOfCollection, NSError *error){
        self.arrayOfCollection = tempArrayOfCollection;
    }];
    self.collectionTableView.arrayOfCollection = self.arrayOfCollection;
    [self.collectionTableView.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfCollection.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionArtcleCell* collectionArtcleCell = [tableView dequeueReusableCellWithIdentifier:@"CollectionArtcleCell"];
    collectionArtcleCell.nameLabel.text = self.arrayOfCollection[indexPath.row][@"title"];
    collectionArtcleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString* iconURL = self.arrayOfCollection[indexPath.row][@"image"];
    NSURL* URL = [NSURL URLWithString:iconURL];
    [[SDWebImageManager sharedManager] loadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            collectionArtcleCell.nameImageView.image = image;
        } else {
            NSLog(@"图片加载失败");
        }
    }];
    NSLog(@"zhexie:%@", collectionArtcleCell.contentView.subviews);
    return collectionArtcleCell;
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionWebviewController* collectionWebviewController = [[CollectionWebviewController alloc] init];
    collectionWebviewController.allArray = [[NSMutableArray alloc] init];
    collectionWebviewController.allArray = self.arrayOfCollection;
    collectionWebviewController.page = indexPath.row + 1;
    collectionWebviewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:collectionWebviewController animated:YES completion:nil];
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
