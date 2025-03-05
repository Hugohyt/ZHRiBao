//
//  homeViewController.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/22.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "Manager.h"
#import "SubModel.h"
#import "TopSubModel.h"
#import "SDWebImage.h"
#import "ScrollerCell.h"
#import "ArticleCell.h"
#import "BeforeModel.h"
#import "BeforeSubModel.h"
#import "WebViewController.h"
#import "BeforeModel.h"
#import "TopWebViewController.h"
#import "CollectionController.h"
#import "FMDB.h"
#import "DatabaseManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"zaizhe:%d",self.page);
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.beforeArray = [[NSMutableArray alloc] init];
    self.allArray = [[NSMutableArray alloc] init];
    self.date = [NSDate date];
    DatabaseManager *databaseManager = [DatabaseManager shareManeger];
    [databaseManager databaseInit];
    dispatch_group_t group = dispatch_group_create();
    Manager *manager = [Manager shareManeger];

    // 进行网络请求
    dispatch_group_enter(group);
    [manager NetWorkGetWithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
        if (!error) {
            self.homeModel = [HomeModel yy_modelWithDictionary:userData];
            NSArray *array = self.homeModel.stories;
            for (SubModel *subModel in array) {
                [self.allArray addObject:[subModel yy_modelToJSONObject]];
            }
            NSLog(@"cishi:%d",[self.allArray count]);
        }
        dispatch_group_leave(group); // 这个需要在所有请求的最后调用
    }];

    // 确保所有请求和图片加载完成后才更新 UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 在这里进行视图更新
        self.homeView = [[HomeView alloc] initWithFrame:self.view.frame];
        [self.homeView.icon addTarget:self action:@selector(pushCollectionView) forControlEvents:UIControlEventTouchUpInside];
        self.homeView.tableView.delegate = self;
        self.homeView.tableView.dataSource = self;
        self.homeView.tableView.userInteractionEnabled = YES;
        [self.homeView.tableView reloadData];
        [self.view addSubview:self.homeView];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePage:) name:@"Page" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"update" object:nil];
    
}

- (void)pushCollectionView{
    CollectionController* collectionController = [[CollectionController alloc] init];
    collectionController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:collectionController animated:YES completion:nil];
}

- (void)update:(NSNotification*)send {
    self.allArray = send.userInfo[@"allArray"];
    [self.beforeArray addObject:send.userInfo[@"beforeModel"]];
    self.date = send.userInfo[@"date"];
    NSLog(@"tianjia:%@",send.userInfo[@"beforeModel"]);
    [self.homeView.tableView reloadData];
    self.homeView.footer.frame = CGRectMake(0, self.homeView.tableView.contentSize.height + 300, 394, 50);
    [self.homeView.footerLabel setText:@"下拉可以刷新"];
    self.homeView.footerRefreshing = NO;
}

- (void)updatePage:(NSNotification *)send {
    self.page = [send.userInfo[@"page"] intValue];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        ScrollerCell* cell = [self.homeView.tableView dequeueReusableCellWithIdentifier:@"ScrollerCell"];
        
        for (int i = 0; i <= self.homeModel.top_stories.count + 4; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            if (i == 9) {
                imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
            } else {
                imageView.frame = CGRectMake((i + 1) * 394, 0, 394, 400);
            }
            TopSubModel* topSubModel = self.homeModel.top_stories[i % 5];
            NSString* iconURL = topSubModel.image;
            NSURL* URL = [NSURL URLWithString:iconURL];
            [[SDWebImageManager sharedManager] loadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    imageView.image = image;
                    [cell.scrollView addSubview:imageView];
                    [cell.scrollView sendSubviewToBack:imageView];
                } else {
                    NSLog(@"图片加载失败");
                }
            }];
            
            UILabel* label = [[UILabel alloc] init];
            if (i == 9) {
                label.frame = CGRectMake(30, 270, 364, 80);
            } else {
                label.frame = CGRectMake(30 + (i + 1) * 394, 270, 364, 80);
            }
            [label setText:topSubModel.title];
            [label setTextColor:[UIColor whiteColor]];
            [label setFont:[UIFont systemFontOfSize:20]];
            label.numberOfLines = 2;
            [cell.scrollView addSubview:label];
            
            UILabel* writerLabel = [[UILabel alloc] init];
            if (i == 9) {
                writerLabel.frame = CGRectMake(30, 340, 300, 20);
            } else {
                writerLabel.frame = CGRectMake(30 + (i + 1) * 394, 340, 300, 20);
            }
            [writerLabel setText:topSubModel.hint];
            [writerLabel setTextColor:[UIColor lightGrayColor]];
            [writerLabel setFont:[UIFont systemFontOfSize:18]];
            [cell.scrollView addSubview:writerLabel];
        }
        [cell.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * 1, 0)];
        return cell;
    } else if (indexPath.section == 0 && indexPath.row != 0) {
        ArticleCell* cell = [self.homeView.tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
        SubModel *subModel = self.homeModel.stories[indexPath.row - 1];
        [cell.label setText:subModel.title];
        [cell.writerLabel setText:subModel.hint];
            NSString* iconURL = subModel.images[0];
            NSURL* URL = [NSURL URLWithString:iconURL];
            [[SDWebImageManager sharedManager] loadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    cell.imageView1.image = image;
                } else {
                    NSLog(@"图片加载失败");
                }
            }];
        return cell;
    } else {
        ArticleCell* cell = [self.homeView.tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
        BeforeModel *beforeModel = self.beforeArray[indexPath.section - 1];
        BeforeSubModel *beforeSubModel = beforeModel.stories[indexPath.row];
        [cell.label setText:beforeSubModel.title];
        [cell.writerLabel setText:beforeSubModel.hint];
            NSString* iconURL = beforeSubModel.images[0];
            NSURL* URL = [NSURL URLWithString:iconURL];
            [[SDWebImageManager sharedManager] loadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    cell.imageView1.image = image;
                } else {
                    NSLog(@"图片加载失败");
                }
            }];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.beforeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.homeModel.stories.count + 1;;
    } else {
        BeforeModel* beforeModel = [[BeforeModel alloc] init];
        beforeModel = self.beforeArray[section - 1];
        return beforeModel.stories.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 400;
    } else {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.homeView.tableView.frame.size.width, 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        BeforeModel *beforeModel = self.beforeArray[section - 1];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:beforeModel.date];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width - 20, headerView.frame.size.height)];
        [formatter setDateFormat:@"MM月dd日"];
        NSString* dateString = [formatter stringFromDate:date];
        headerLabel.text = dateString;
        headerLabel.textColor = [UIColor lightGrayColor];
        headerLabel.font = [UIFont systemFontOfSize:18];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 26, 344, 1)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        
        [headerView addSubview:imageView];
        [headerView addSubview:headerLabel];
        return  headerView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dealFooter];
}

- (void)dealFooter {
    if (self.homeView.footerRefreshing) {
        return;
    }
    CGFloat footerOffset = self.homeView.tableView.contentSize.height - self.homeView.tableView.frame.size.height + self.homeView.footerLabel.frame.size.height;
//    NSLog(@"%d %d %d", self.homeView.tableView.contentSize.height, self.homeView.tableView.frame.size.height, self.homeView.footerLabel.frame.size.height);
    if (self.homeView.tableView.contentOffset.y >= footerOffset) {
        [self footerBeginRefreshing];
    }
}

- (void)footerBeginRefreshing {
    if (self.homeView.footerRefreshing) {
        return;
    }
    [self.homeView.footerLabel setText:@"正在刷新数据"];
    self.homeView.footerRefreshing = YES;
//    [UIView animateWithDuration:0.25 animations:^{
//        UIEdgeInsets inset = self.homeView.tableView.contentInset;
//        inset.top += self.homeView.footerLabel.bounds.size.height;
//        self.homeView.tableView.contentInset = inset;
//    }];
    [self reloadDate];
}

- (void)reloadDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString* dateString = [formatter stringFromDate:self.date];
    NSLog(@"%@", dateString);
    dispatch_group_t group = dispatch_group_create();
    Manager *manager = [Manager shareManeger];
    // 进行网络请求
    dispatch_group_enter(group);
    [manager NetWorkGetBefore: dateString WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
        if (!error) {
            BeforeModel* beforeModel = [[BeforeModel alloc] init];
            beforeModel = [BeforeModel yy_modelWithDictionary:userData];
            [self.beforeArray addObject:beforeModel];
            NSArray *array = beforeModel.stories;
            for (BeforeSubModel *beforeSubModel in array) {
                [self.allArray addObject:[beforeSubModel yy_modelToJSONObject]];
            }
            NSLog(@"%@",self.allArray);
        }
        dispatch_group_leave(group); // 这个需要在所有请求的最后调用
    }];
    
    // 确保所有请求和图片加载完成后才更新 UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 在这里进行视图更新
        [self.homeView.tableView reloadData];
        self.homeView.footer.frame = CGRectMake(0, self.homeView.tableView.contentSize.height + 300, 394, 50);
        [self.homeView.footerLabel setText:@"下拉可以刷新"];
        self.homeView.footerRefreshing = NO;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *oneDayBeforeComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.date];
        oneDayBeforeComponents.day -= 1;
        if (oneDayBeforeComponents.day < 1) {
            NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date];
            oneDayBeforeComponents.day = dayRange.length;
            oneDayBeforeComponents.month -= 1;
            if (oneDayBeforeComponents.month < 1) {
                oneDayBeforeComponents.month = 12;
                oneDayBeforeComponents.year -= 1;
                NSRange newDayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date];
                oneDayBeforeComponents.day = newDayRange.length;
            }
        }
        self.date = [calendar dateFromComponents:oneDayBeforeComponents];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.page == 2147483647) {
            self.page = 0;
        }
        TopWebViewController* topWebController = [[TopWebViewController alloc] init];
        topWebController.modalPresentationStyle = UIModalPresentationFullScreen;
        NSDictionary *dictionary = [self.homeModel yy_modelToJSONObject];
        topWebController.topArray = [[NSMutableArray alloc] init];
        topWebController.topArray = (NSMutableArray*)dictionary[@"top_stories"];
        topWebController.page = self.page;
        NSLog(@"page:%d",self.page);
        [self presentViewController:topWebController animated:YES completion:nil];
    } else if (indexPath.section == 0 && indexPath.row != 0) {
       WebViewController* webController = [[WebViewController alloc] init];
        webController.modalPresentationStyle = UIModalPresentationFullScreen;
        webController.date = [[NSDate alloc] init];
        webController.date = self.date;
        SubModel *subModel = [[SubModel alloc] init];
        subModel = self.homeModel.stories[indexPath.row - 1];
        webController.webUrl = subModel.url;
        int sum = 0;
        if (indexPath.section > 0) {
            sum += self.homeModel.stories.count;
        }
        for (int i = 0; i < indexPath.section; i++) {
            BeforeModel *beforeModel = self.beforeArray[i];
            sum += beforeModel.stories.count;
        }
        webController.page = sum + indexPath.row;
        NSLog(@"%d %d",sum, indexPath.row);
        NSLog(@"%d %d %d",webController.page, indexPath.section, indexPath.row);
        webController.allArray = [[NSMutableArray alloc] init];
        webController.allArray = self.allArray;
        NSLog(@"%d",[self.allArray count]);
        [self presentViewController:webController animated:YES completion:nil];
    } else if (indexPath.section != 0) {
        WebViewController* webController = [[WebViewController alloc] init];
        webController.modalPresentationStyle = UIModalPresentationFullScreen;
        webController.date = [[NSDate alloc] init];
        webController.date = self.date;
        BeforeModel *beforeModel = [[BeforeModel alloc] init];
        beforeModel = self.beforeArray[indexPath.section - 1];
        BeforeSubModel* beforeSubModel = beforeModel.stories[indexPath.row];
        webController.webUrl = beforeSubModel.url;
        int sum = 0;
        sum += self.homeModel.stories.count;
        for (int i = 1; i < indexPath.section; i++) {
            BeforeModel *beforeModel = self.beforeArray[i];
            sum += beforeModel.stories.count;
        }
        webController.page = sum + indexPath.row + 1;
        NSLog(@"%d %d %d",webController.page, indexPath.section, indexPath.row);
        webController.allArray = [[NSMutableArray alloc] init];
        webController.allArray = self.allArray;
        [self presentViewController:webController animated:YES completion:nil];
    }
}

- (void)passPage: (int)page{
    self.page = page;
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
