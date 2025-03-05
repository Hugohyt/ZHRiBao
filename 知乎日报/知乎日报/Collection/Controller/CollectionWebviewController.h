//
//  CollectionWebviewController.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/18.
//

#import <UIKit/UIKit.h>
#import "CollectionWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionWebviewController : UIViewController <UIScrollViewDelegate>

@property NSString *webUrl;
@property NSMutableArray *allArray;
@property NSInteger page;
@property NSNumber *newpage;
@property CollectionWebview *collectionWebview;
@property NSMutableSet *pageSet;
@property NSDate* date;
@property NSInteger CurrentPageForButton;

@end

NS_ASSUME_NONNULL_END
