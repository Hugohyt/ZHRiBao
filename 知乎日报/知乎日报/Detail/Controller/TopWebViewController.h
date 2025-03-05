//
//  TopWebViewController.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/3.
//

#import <UIKit/UIKit.h>
#import "WKWebView+AFNetworking.h"
#import "TopWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopWebViewController : UIViewController <UIScrollViewDelegate>

@property NSString *webUrl;
@property NSMutableArray *topArray;
@property NSInteger page;
@property NSNumber *newpage;
@property BOOL isLoadingMoreData;
@property TopWebView *topWebview;
@property NSMutableSet *pageSet;
@property NSDate* date;
@property NSInteger CurrentPageForButton;

@end

NS_ASSUME_NONNULL_END
