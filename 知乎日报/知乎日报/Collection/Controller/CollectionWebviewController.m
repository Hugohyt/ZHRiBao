//
//  CollectionWebviewController.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/18.
//

#import "CollectionWebviewController.h"
#import "CollectionWebview.h"
#import "DatabaseManager.h"
#import "CommentViewController.h"
#import "Manager.h"
#import "ExtraModel.h"
#import "YYModel.h"

BOOL isLoadingWebView2;

@interface CollectionWebviewController ()

@end

@implementation CollectionWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}
    
- (void)loadWebView {
    
    self.collectionWebview = [[CollectionWebview alloc] init];
    self.collectionWebview.page = self.page;
    self.CurrentPageForButton = self.page;
    self.collectionWebview.frame = self.view.frame;
    self.collectionWebview.allArray = [[NSMutableArray alloc] init];
    self.collectionWebview.allArray = self.allArray;
    
    DatabaseManager* databaseManager = [DatabaseManager shareManeger];
    NSLog(@"id:%@",self.allArray[self.CurrentPageForButton - 1][@"id"]);
    if ([databaseManager queryLikeData:self.allArray[self.CurrentPageForButton - 1][@"id"]]) {
        self.collectionWebview.likeButton.tag = 102;
    } else {
        self.collectionWebview.likeButton.tag = 101;
    }
    if ([databaseManager queryCollectionData:self.allArray[self.CurrentPageForButton - 1][@"id"]]) {
        self.collectionWebview.starButton.tag = 102;
    } else {
        self.collectionWebview.starButton.tag = 101;
    }
    
    if (self.collectionWebview.likeButton.tag == 101) {
        [self.collectionWebview.likeButton setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
    } else {
        [self.collectionWebview.likeButton setImage:[UIImage imageNamed:@"已点赞.jpg"] forState:UIControlStateNormal];
    }
    if (self.collectionWebview.starButton.tag == 101) {
        [self.collectionWebview.starButton setImage:[UIImage imageNamed:@"收藏.jpg"] forState:UIControlStateNormal];
    } else {
        [self.collectionWebview.starButton setImage:[UIImage imageNamed:@"已收藏.jpg"] forState:UIControlStateNormal];
    }
    
    self.pageSet = [[NSMutableSet alloc] init];
    self.collectionWebview.scrollView.delegate = self;
    [self.collectionWebview loadView];
    [self.view addSubview:self.collectionWebview];
    
    [self.collectionWebview.exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionWebview.commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionWebview.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionWebview.starButton addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionWebview.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
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
        int num = [self.collectionWebview.likeLabel.text intValue];
        num = num + 1;
        [self.collectionWebview.likeLabel setText:[NSString stringWithFormat:@"%d", num]];
        NSLog(@"text:%@",self.collectionWebview.likeLabel.text);
        DatabaseManager *dataManager = [DatabaseManager shareManeger];
        [dataManager insertLikeDatabase:self.allArray[self.CurrentPageForButton - 1][@"id"]];
    } else {
        button.tag = 101;
        [button setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
        int num = [self.collectionWebview.likeLabel.text intValue];
        num = num - 1;
        [self.collectionWebview.likeLabel setText:[NSString stringWithFormat:@"%d",num]];
        NSLog(@"text:%@",self.collectionWebview.likeLabel.text);
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
    if(isLoadingWebView2 == NO) {
        NSLog(@"好的");
        dispatch_group_t group = dispatch_group_create();
        Manager *manager = [Manager shareManeger];
        
        // 进行网络请求
        dispatch_group_enter(group);
        [manager NetWorkGetFor:self.allArray[currentPage - 1][@"id"]WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
            if (!error) {
                ExtraModel* extraModel = [ExtraModel yy_modelWithDictionary:userData];
                DatabaseManager* databaseManager = [DatabaseManager shareManeger];
                if ([databaseManager queryLikeData:self.allArray[currentPage - 1][@"id"]]) {
                    self.collectionWebview.likeButton.tag = 102;
                    [self.collectionWebview.likeButton setImage:[UIImage imageNamed:@"已点赞.jpg"] forState:UIControlStateNormal];
                    self.collectionWebview.likeLabel.text = [NSString stringWithFormat:@"%d",extraModel.popularity + 1];
                } else {
                    self.collectionWebview.likeButton.tag = 101;
                    [self.collectionWebview.likeButton setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
                    self.collectionWebview.likeLabel.text = [NSString stringWithFormat:@"%d",extraModel.popularity];
                }
                if ([databaseManager queryCollectionData:self.allArray[currentPage - 1][@"id"]]) {
                    self.collectionWebview.starButton.tag = 102;
                    [self.collectionWebview.starButton setImage:[UIImage imageNamed:@"已收藏.jpg"] forState:UIControlStateNormal];
                } else {
                    self.collectionWebview.starButton.tag = 101;
                    [self.collectionWebview.starButton setImage:[UIImage imageNamed:@"收藏.jpg"] forState:UIControlStateNormal];
                }
                self.collectionWebview.commentLabel.text = [NSString stringWithFormat:@"%d",extraModel.comments];
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

    if (currentPage != (self.collectionWebview.page) && isLoadingWebView2 == NO && ![self.pageSet containsObject:self.newpage]) {
        NSLog(@"yin:%d %d %d",self.collectionWebview.page ,currentPage, [self.allArray count]);
        isLoadingWebView2 = YES;
        self.collectionWebview.page = currentPage;
        [self.pageSet addObject:self.newpage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPageForCollection" object:nil userInfo:nil];
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
