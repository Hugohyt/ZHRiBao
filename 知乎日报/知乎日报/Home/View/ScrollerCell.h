//
//  ScrollerCell.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollerCell : UITableViewCell <UIScrollViewDelegate>

@property UIScrollView *scrollView;
@property NSTimer *timer;
@property NSInteger currentPage;
@property UIPageControl* pageControl;

@end

NS_ASSUME_NONNULL_END
