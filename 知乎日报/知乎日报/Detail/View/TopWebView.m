//
//  TopWebView.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/3.
//

#import "TopWebView.h"
#import "topSubModel.h"
#import "Masonry.h"
#import "Manager.h"
#import "ExtraModel.h"
#import "YYModel.h"

extern BOOL isLoadingWebView1;

@implementation TopWebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.wkWebView = [[WKWebView alloc] init];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 852);
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutNewTopWebView) name:@"newTop" object:nil];
    return self;
}

- (void)loadButton {
    CGFloat Width = 394 / 5;
    
    self.starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSLog(@"%@",self.topArray[self.page - 1]);
    
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

- (void)layoutNewTopWebView {
    NSLog(@"zhege");
    self.wkWebView = [[WKWebView alloc] init];
    NSLog(@"ye:%d",self.page);
    NSURL* urlWeb = [NSURL URLWithString:self.topArray[self.page][@"url"]];
    NSURLRequest* webRequest = [[NSURLRequest alloc] initWithURL:urlWeb];
    [self.wkWebView loadRequest:webRequest];
    self.wkWebView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (self.page), 0, 393, 872);
    [self.scrollView addSubview:self.wkWebView];
    NSLog(@"%d",self.page);
    NSLog(@"%@",self.wkWebView);
    isLoadingWebView1 = NO;
    if (self.wkWebView == nil) {
        NSLog(@"no");
    }
    NSLog(@"OK");
}


- (void)loadView {
    NSLog(@"shuliang:%d",[self.topArray count]);
    NSLog(@"%d",self.page);
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 5, 852);
    NSLog(@"%@", self.topArray[(int)self.page][@"url"]);
    NSURL *urlWeb = [NSURL URLWithString:self.topArray[(int)self.page][@"url"]];
    NSURLRequest *webRequest = [[NSURLRequest alloc] initWithURL:urlWeb];
    [self.wkWebView loadRequest:webRequest];
    self.wkWebView.frame = CGRectMake((self.page) * [UIScreen mainScreen].bounds.size.width, 0, 393, 852);
    [self.scrollView setContentOffset:CGPointMake((self.page) * [UIScreen mainScreen].bounds.size.width, 0)];
    
    dispatch_group_t group = dispatch_group_create();
    Manager *manager = [Manager shareManeger];

    // 进行网络请求
    dispatch_group_enter(group);
    [manager NetWorkGetFor:self.topArray[self.page][@"id"]WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
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

@end
