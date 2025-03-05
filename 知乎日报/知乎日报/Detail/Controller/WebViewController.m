//
//  WebViewController.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/31.
//

#import "WebViewController.h"
#import "UIKit+AFNetworking.h"
#import "webView.h"
#import "Manager.h"
#import "BeforeModel.h"
#import "YYModel.h"
#import "Masonry.h"
#import "BeforeSubModel.h"
#import "ExtraModel.h"
#import "CommentViewController.h"
#import "DatabaseManager.h"

BOOL isLoadingWebView;

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadWebView];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}
    
- (void)loadWebView {
    
    self.webview = [[webView alloc] init];
    self.webview.page = self.page;
    self.CurrentPageForButton = self.page;
    self.webview.frame = self.view.frame;
    self.webview.allArray = [[NSMutableArray alloc] init];
    self.webview.allArray = self.allArray;
    
    DatabaseManager* databaseManager = [DatabaseManager shareManeger];
    if ([databaseManager queryLikeData:self.allArray[self.CurrentPageForButton - 1][@"id"]]) {
        self.webview.likeButton.tag = 102;
    } else {
        self.webview.likeButton.tag = 101;
    }
    if ([databaseManager queryCollectionData:self.allArray[self.CurrentPageForButton - 1][@"id"]]) {
        self.webview.starButton.tag = 102;
    } else {
        self.webview.starButton.tag = 101;
    }
    
    if (self.webview.likeButton.tag == 101) {
        [self.webview.likeButton setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
    } else {
        NSLog(@"tag:%d",self.webview.likeButton.tag);
        [self.webview.likeButton setImage:[UIImage imageNamed:@"已点赞.jpg"] forState:UIControlStateNormal];
    }
    if (self.webview.starButton.tag == 101) {
        [self.webview.starButton setImage:[UIImage imageNamed:@"收藏.jpg"] forState:UIControlStateNormal];
    } else {
        [self.webview.starButton setImage:[UIImage imageNamed:@"已收藏.jpg"] forState:UIControlStateNormal];
    }
    
    self.pageSet = [[NSMutableSet alloc] init];
    self.webview.scrollView.delegate = self;
    [self.webview loadView];
    [self.view addSubview:self.webview];
    
    [self.webview.exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.webview.commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [self.webview.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [self.webview.starButton addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
    [self.webview.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)share {
    NSLog(@"1");
}

- (void)star:(UIButton*)button {
    if (button.tag == 101) {
        button.tag = 102;
        [button setImage:[UIImage imageNamed:@"已收藏.jpg"] forState:UIControlStateNormal];
        DatabaseManager *dataManager = [DatabaseManager shareManeger];
        [dataManager insertCollectionDatabaseWithId:self.allArray[self.CurrentPageForButton - 1][@"id"] andTile:self.allArray[self.CurrentPageForButton - 1][@"title"] andImage:self.allArray[self.CurrentPageForButton - 1][@"images"][0] andURL:self.allArray[self.CurrentPageForButton - 1][@"url"]];
    } else {
        button.tag = 101;
        [button setImage:[UIImage imageNamed:@"收藏.jpg"] forState:UIControlStateNormal];
        DatabaseManager* dataManager = [DatabaseManager shareManeger];
        [dataManager deleteCollectionData:self.allArray[self.CurrentPageForButton - 1][@"id"]];
    }
}

- (void)like:(UIButton*)button {
    if (button.tag == 101) {
        button.tag = 102;
        [button setImage:[UIImage imageNamed:@"已点赞.jpg"] forState:UIControlStateNormal];
        int num = [self.webview.likeLabel.text intValue];
        num = num + 1;
        [self.webview.likeLabel setText:[NSString stringWithFormat:@"%d", num]];
        NSLog(@"text:%@",self.webview.likeLabel.text);
        DatabaseManager *dataManager = [DatabaseManager shareManeger];
        [dataManager insertLikeDatabase:self.allArray[self.CurrentPageForButton - 1][@"id"]];
    } else {
        button.tag = 101;
        [button setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
        int num = [self.webview.likeLabel.text intValue];
        num = num - 1;
        [self.webview.likeLabel setText:[NSString stringWithFormat:@"%d",num]];
        NSLog(@"text:%@",self.webview.likeLabel.text);
        DatabaseManager* dataManager = [DatabaseManager shareManeger];
        [dataManager deleteLikeData:self.allArray[self.CurrentPageForButton - 1][@"id"]];
    }
}

- (void)comment {
    CommentViewController* commentViewController = [[CommentViewController alloc] init];
    commentViewController.id = self.allArray[self.CurrentPageForButton - 1][@"id"];
    commentViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:commentViewController animated:YES completion:nil];
}

- (void)exit {
    NSLog(@"执行");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = (scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width) + 1;
    NSLog(@"currentPage:%d",currentPage);
    NSLog(@"qian:%d",_isLoadingMoreData);
    if(isLoadingWebView == NO && _isLoadingMoreData == NO) {
        NSLog(@"hou:%d",_isLoadingMoreData);
        dispatch_group_t group = dispatch_group_create();
        Manager *manager = [Manager shareManeger];
        
        // 进行网络请求
        dispatch_group_enter(group);
        [manager NetWorkGetFor:self.allArray[currentPage - 1][@"id"]WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
            if (!error) {
                ExtraModel* extraModel = [ExtraModel yy_modelWithDictionary:userData];
                DatabaseManager* databaseManager = [DatabaseManager shareManeger];
                if ([databaseManager queryLikeData:self.allArray[currentPage - 1][@"id"]]) {
                    self.webview.likeButton.tag = 102;
                    [self.webview.likeButton setImage:[UIImage imageNamed:@"已点赞.jpg"] forState:UIControlStateNormal];
                    self.webview.likeLabel.text = [NSString stringWithFormat:@"%d",extraModel.popularity + 1];
                    NSLog(@"text:%@",self.webview.likeLabel.text);
                } else {
                    self.webview.likeButton.tag = 101;
                    [self.webview.likeButton setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
                    self.webview.likeLabel.text = [NSString stringWithFormat:@"%d",extraModel.popularity];
                }
                if ([databaseManager queryCollectionData:self.allArray[currentPage - 1][@"id"]]) {
                    self.webview.starButton.tag = 102;
                    [self.webview.starButton setImage:[UIImage imageNamed:@"已收藏.jpg"] forState:UIControlStateNormal];
                } else {
                    self.webview.starButton.tag = 101;
                    [self.webview.starButton setImage:[UIImage imageNamed:@"收藏.jpg"] forState:UIControlStateNormal];
                }
                self.webview.commentLabel.text = [NSString stringWithFormat:@"%d",extraModel.comments];
                self.CurrentPageForButton = currentPage;
            }
            dispatch_group_leave(group);
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        });
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x <= 0) {
            // 滚动到最左端，禁止继续向左滑动
            scrollView.contentOffset = CGPointMake(0, 0);
        }
    
    NSInteger currentPage = (scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width) + 1;
    self.newpage= [NSNumber numberWithInteger:currentPage + 5];

        // 当滚动视图向右滚动且快接近画布右边缘时，触发加载数据的操作
    if (scrollView.contentOffset.x >  ([self.allArray count] * [UIScreen mainScreen].bounds.size.width  - [UIScreen mainScreen].bounds.size.width * 1.5) && self.isLoadingMoreData == NO) {
        self.isLoadingMoreData = YES;
        [self loadMoreData:(NSInteger)currentPage + 1];
    }
    if (currentPage != (self.webview.page) && isLoadingWebView == NO && self.isLoadingMoreData == NO && ![self.pageSet containsObject:self.newpage]) {
        NSLog(@"yin:%d %d %d",self.webview.page ,currentPage, [self.allArray count]);
        isLoadingWebView = YES;
        self.webview.page = currentPage;
        [self.pageSet addObject:self.newpage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPage" object:nil userInfo:nil];
    }
}

- (void)loadMoreData:(NSInteger)currentPage {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString* dateString = [formatter stringFromDate:self.date];
    NSLog(@"%@", dateString);
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    dispatch_group_t group = dispatch_group_create();
    Manager *manager = [Manager shareManeger];
    // 进行网络请求
    dispatch_group_enter(group);
    [manager NetWorkGetBefore: dateString WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
        if (!error) {
            BeforeModel* beforeModel = [[BeforeModel alloc] init];
            beforeModel = [BeforeModel yy_modelWithDictionary:userData];
            NSArray *array = beforeModel.stories;
            for (BeforeSubModel *beforeSubModel in array) {
                [self.allArray addObject:[beforeSubModel yy_modelToJSONObject]];
            }
            [updateDictionary setValue:beforeModel forKey:@"beforeModel"];
            [updateDictionary setValue:self.allArray forKey:@"allArray"];
        }
        dispatch_group_leave(group); // 这个需要在所有请求的最后调用
    }];

    // 确保所有请求和图片加载完成后才更新 UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 在这里进行视图更新
        
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
        [updateDictionary setValue:self.date forKey:@"date"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:updateDictionary];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"layoutNewScrollView" object:nil userInfo:nil];
        self.isLoadingMoreData = NO; // 重置加载标志
        if (currentPage != (self.webview.page) && isLoadingWebView == NO && self.isLoadingMoreData == NO && ![self.pageSet containsObject:self.newpage]) {
            isLoadingWebView = YES;
            self.webview.page = currentPage;
            [self.pageSet addObject:self.newpage];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newPage" object:nil userInfo:nil];
        }
        
    });
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
