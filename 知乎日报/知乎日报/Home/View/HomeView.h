//
//  homeView.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeView : UIView

@property UIImageView *imageView1;
@property UILabel *textLabel;
@property UILabel *dateLabel;
@property UIButton *icon;

@property UITableView *tableView;
@property UIView *footer;
@property UILabel *footerLabel;
@property BOOL footerRefreshing;

@end

NS_ASSUME_NONNULL_END
