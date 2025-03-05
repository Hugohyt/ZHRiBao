//
//  WebViewController.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/31.
//

#import <UIKit/UIKit.h>
#import "webView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <UIScrollViewDelegate>

@property NSString *webUrl;
@property NSMutableArray *allArray;
@property NSInteger page;
@property NSNumber *newpage;
@property BOOL isLoadingMoreData;
@property webView *webview;
@property NSMutableSet *pageSet;
@property NSDate* date;
@property NSInteger CurrentPageForButton;

@end

NS_ASSUME_NONNULL_END
