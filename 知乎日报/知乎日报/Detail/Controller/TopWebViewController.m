//
//  TopWebViewController.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/3.
//

#import "TopWebViewController.h"
#import "Manager.h"
#import "DatabaseManager.h"
#import "CommentViewController.h"
#import "YYModel.h"

BOOL isLoadingWebView1;

@interface TopWebViewController ()

@end

@implementation TopWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
}

- (void)loadWebView {
    
    self.topWebview = [[TopWebView alloc] init];
    self.topWebview.page = self.page;
    self.topWebview.frame = self.view.frame;
    self.topWebview.topArray = [[NSMutableArray alloc] init];
    self.topWebview.topArray = self.topArray;
    self.CurrentPageForButton = self.page + 1;
    
    DatabaseManager* databaseManager = [DatabaseManager shareManeger];
    if ([databaseManager queryLikeData:self.topArray[self.CurrentPageForButton - 1][@"id"]]) {
        self.topWebview.likeButton.tag = 102;
    } else {
        self.topWebview.likeButton.tag = 101;
    }
    if ([databaseManager queryCollectionData:self.topArray[self.CurrentPageForButton - 1][@"id"]]) {
        self.topWebview.starButton.tag = 102;
    } else {
        self.topWebview.starButton.tag = 101;
    }
    
    if (self.topWebview.likeButton.tag == 101) {
        [self.topWebview.likeButton setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
    } else {
        NSLog(@"tag:%d",self.topWebview.likeButton.tag);
        [self.topWebview.likeButton setImage:[UIImage imageNamed:@"已点赞.jpg"] forState:UIControlStateNormal];
    }
    if (self.topWebview.starButton.tag == 101) {
        [self.topWebview.starButton setImage:[UIImage imageNamed:@"收藏.jpg"] forState:UIControlStateNormal];
    } else {
        [self.topWebview.starButton setImage:[UIImage imageNamed:@"已收藏.jpg"] forState:UIControlStateNormal];
    }
    
    self.pageSet = [[NSMutableSet alloc] init];
    self.topWebview.scrollView.delegate = self;
    [self.topWebview loadView];
    [self.view addSubview:self.topWebview];
    
    [self.topWebview.exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.topWebview.commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [self.topWebview.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWebview.starButton addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWebview.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
}

- (void)share {
    NSLog(@"1");
}

- (void)star:(UIButton*)button {
    if (button.tag == 101) {
        button.tag = 102;
        [button setImage:[UIImage imageNamed:@"已收藏.jpg"] forState:UIControlStateNormal];
        DatabaseManager *dataManager = [DatabaseManager shareManeger];
        [dataManager insertCollectionDatabaseWithId:self.topArray[self.CurrentPageForButton - 1][@"id"] andTile:self.topArray[self.CurrentPageForButton - 1][@"title"] andImage:self.topArray[self.CurrentPageForButton - 1][@"image"] andURL:self.topArray[self.CurrentPageForButton - 1][@"url"]];
    } else {
        button.tag = 101;
        [button setImage:[UIImage imageNamed:@"收藏.jpg"] forState:UIControlStateNormal];
        DatabaseManager* dataManager = [DatabaseManager shareManeger];
        [dataManager deleteCollectionData:self.topArray[self.CurrentPageForButton - 1][@"id"]];
    }
}

- (void)like:(UIButton*)button {
    if (button.tag == 101) {
        button.tag = 102;
        [button setImage:[UIImage imageNamed:@"已点赞.jpg"] forState:UIControlStateNormal];
        int num = [self.topWebview.likeLabel.text intValue];
        num = num + 1;
        [self.topWebview.likeLabel setText:[NSString stringWithFormat:@"%d", num]];
        NSLog(@"text:%@",self.topWebview.likeLabel.text);
        DatabaseManager *dataManager = [DatabaseManager shareManeger];
        [dataManager insertLikeDatabase:self.topArray[self.CurrentPageForButton - 1][@"id"]];
    } else {
        button.tag = 101;
        [button setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
        int num = [self.topWebview.likeLabel.text intValue];
        num = num - 1;
        [self.topWebview.likeLabel setText:[NSString stringWithFormat:@"%d",num]];
        NSLog(@"text:%@",self.topWebview.likeLabel.text);
        DatabaseManager* dataManager = [DatabaseManager shareManeger];
        [dataManager deleteLikeData:self.topArray[self.CurrentPageForButton - 1][@"id"]];
    }
}

- (void)comment {
    CommentViewController* commentViewController = [[CommentViewController alloc] init];
    commentViewController.id = self.topArray[self.CurrentPageForButton - 1][@"id"];
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
    if(isLoadingWebView1 == NO && _isLoadingMoreData == NO) {
        dispatch_group_t group = dispatch_group_create();
        Manager *manager = [Manager shareManeger];
        
        // 进行网络请求
        dispatch_group_enter(group);
        [manager NetWorkGetFor:self.topArray[currentPage - 1][@"id"]WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
            if (!error) {
                ExtraModel* extraModel = [ExtraModel yy_modelWithDictionary:userData];
                DatabaseManager* databaseManager = [DatabaseManager shareManeger];
                if ([databaseManager queryLikeData:self.topArray[currentPage - 1][@"id"]]) {
                    self.topWebview.likeButton.tag = 102;
                    [self.topWebview.likeButton setImage:[UIImage imageNamed:@"已点赞.jpg"] forState:UIControlStateNormal];
                    self.topWebview.likeLabel.text = [NSString stringWithFormat:@"%d",extraModel.popularity + 1];
                    NSLog(@"text:%@",self.topWebview.likeLabel.text);
                } else {
                    self.topWebview.likeButton.tag = 101;
                    [self.topWebview.likeButton setImage:[UIImage imageNamed:@"点赞.jpg"] forState:UIControlStateNormal];
                    self.topWebview.likeLabel.text = [NSString stringWithFormat:@"%d",extraModel.popularity];
                }
                if ([databaseManager queryCollectionData:self.topArray[currentPage - 1][@"id"]]) {
                    self.topWebview.starButton.tag = 102;
                    [self.topWebview.starButton setImage:[UIImage imageNamed:@"已收藏.jpg"] forState:UIControlStateNormal];
                } else {
                    self.topWebview.starButton.tag = 101;
                    [self.topWebview.starButton setImage:[UIImage imageNamed:@"收藏.jpg"] forState:UIControlStateNormal];
                }
                self.topWebview.commentLabel.text = [NSString stringWithFormat:@"%d",extraModel.comments];
                NSLog(@"comments:%d",extraModel.comments);
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
    
    NSInteger currentPage = (scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    self.newpage= [NSNumber numberWithInteger:currentPage + 5];
    if (currentPage != (self.topWebview.page) && isLoadingWebView1 == NO && self.isLoadingMoreData == NO && ![self.pageSet containsObject:self.newpage]) {
        NSLog(@"yin:%d %d %d",self.topWebview.page ,currentPage, [self.topArray count]);
        isLoadingWebView1 = YES;
        self.topWebview.page = currentPage;
        [self.pageSet addObject:self.newpage];
        NSLog(@"在这呢");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newTop" object:self.topWebview userInfo:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newTop" object:nil userInfo:nil];
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
