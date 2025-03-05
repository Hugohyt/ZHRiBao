//
//  TopWebView.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/3.
//

#import <UIKit/UIKit.h>
#import "WKWebView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopWebView : UIView

@property NSInteger page;
@property UIScrollView *scrollView;
@property WKWebView *wkWebView;
@property NSMutableArray *topArray;
@property UIImageView* tabImageView;
@property UIButton* likeButton;
@property UIButton* starButton;
@property UIButton* exitButton;
@property UIButton* shareButton;
@property UIButton* commentButton;
@property UILabel* commentLabel;
@property UILabel* likeLabel;

- (void)loadView;
- (void)loadButton;


@end

NS_ASSUME_NONNULL_END
