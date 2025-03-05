//
//  webView.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/3.
//

#import "webView.h"
#import "Masonry.h"
#import "Manager.h"
#import "ExtraModel.h"
#import "YYModel.h"
#import "DatabaseManager.h"

extern BOOL isLoadingWebView;

@implementation webView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.wkWebView = [[WKWebView alloc] init];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 852);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.wkWebView];
    [self addSubview:self.scrollView];
    
    [self loadTabBar];
    [self loadButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutNewScrollView) name:@"layoutNewScrollView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutNewWebView) name:@"newPage" object:nil];
    return self;
}

- (void)loadButton {
    CGFloat Width = 394 / 5;
    
    self.starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSLog(@"%@",self.allArray[self.page - 1]);
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitButton setImage:[UIImage imageNamed:@"返回.jpg"] forState:UIControlStateNormal];
    [self.tabImageView addSubview:self.exitButton];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setImage:[UIImage imageNamed:@"评论.jpg"] forState:UIControlStateNormal];
    [self.tabImageView addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Width * 1));
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];
    
    
    self.commentLabel = [[UILabel alloc] init];
    [self.tabImageView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right);
        make.top.equalTo(self.tabImageView.mas_top);
        make.width.mas_equalTo(30);
        make.height.equalTo(self.tabImageView.mas_height);
    }];
    
    [self.tabImageView addSubview:self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Width * 2));
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];
    
    
    self.likeLabel = [[UILabel alloc] init];
    [self.tabImageView addSubview:self.likeLabel];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeButton.mas_right);
        make.top.equalTo(self.tabImageView.mas_top);
        make.width.mas_equalTo(30);
        make.height.equalTo(self.tabImageView.mas_height);
    }];
    
    [self.tabImageView addSubview:self.starButton];
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Width * 3));
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:[UIImage imageNamed:@"分享.jpg"] forState:UIControlStateNormal];
    [self.tabImageView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Width * 4));
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];
}

- (void)loadTabBar {
    self.tabImageView = [[UIImageView alloc] init];
    self.tabImageView.userInteractionEnabled = YES;
    [self.tabImageView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1.0]];
    [self addSubview:self.tabImageView];
    [self.tabImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(784);
        make.left.equalTo(self);
        make.width.mas_equalTo(393);
        make.height.mas_equalTo(70);
    }];
}

- (void)layoutNewScrollView {
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * [self.allArray count] + [UIScreen mainScreen].bounds.size.width, 0);
    NSLog(@"执行");
//    CGPoint newContentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * (self.allArray.count - 1) * 5, -59);
//    [self layoutNewWebView];
}

- (void)layoutNewWebView {
    self.wkWebView = [[WKWebView alloc] init];
    NSLog(@"ye:%d",self.page);
    NSURL* urlWeb = [NSURL URLWithString:self.allArray[self.page - 1][@"url"]];
    NSURLRequest* webRequest = [[NSURLRequest alloc] initWithURL:urlWeb];
    [self.wkWebView loadRequest:webRequest];
    self.wkWebView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (self.page - 1), 0, 393, 872);
    [self.scrollView addSubview:self.wkWebView];
    NSLog(@"%d",self.page);
    NSLog(@"%@",self.wkWebView);
    isLoadingWebView = NO;
    if (self.wkWebView == nil) {
        NSLog(@"no");
    }
    NSLog(@"OK");
}


- (void)loadView {
    NSLog(@"shuliang:%d",[self.allArray count]);
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * [self.allArray count], 852);
    NSLog(@"page:%d", self.page);
    NSURL *urlWeb = [NSURL URLWithString:self.allArray[self.page - 1][@"url"]];
    NSURLRequest *webRequest = [[NSURLRequest alloc] initWithURL:urlWeb];
    [self.wkWebView loadRequest:webRequest];
    self.wkWebView.frame = CGRectMake((self.page - 1) * [UIScreen mainScreen].bounds.size.width, 0, 393, 852);
    [self.scrollView setContentOffset:CGPointMake((self.page - 1) * [UIScreen mainScreen].bounds.size.width, 0)];
    dispatch_group_t group = dispatch_group_create();
    Manager *manager = [Manager shareManeger];

    // 进行网络请求
    dispatch_group_enter(group);
    [manager NetWorkGetFor:self.allArray[self.page - 1][@"id"]WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
        if (!error) {
            ExtraModel* extraModel = [ExtraModel yy_modelWithDictionary:userData];
            NSLog(@"%d",extraModel.popularity);
            if (self.likeButton.tag == 101) {
                self.likeLabel.text = [NSString stringWithFormat:@"%d",extraModel.popularity];
            } else{
                self.likeLabel.text = [NSString stringWithFormat:@"%d",extraModel.popularity + 1];
            }
            self.commentLabel.text = [NSString stringWithFormat:@"%d",extraModel.comments];
        }
        dispatch_group_leave(group); // 这个需要在所有请求的最后调用
    }];
    
    // 确保所有请求和图片加载完成后才更新 UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 在这里进行视图更新
        
    });
}

- (void)dealloc {
    // 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newPage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"layoutNewScrollView" object:nil];
}

@end
