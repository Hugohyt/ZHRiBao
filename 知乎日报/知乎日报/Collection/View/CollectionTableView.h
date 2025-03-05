//
//  CollectionTableView.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property UIImageView* headTabView;
@property UITableView* tableView;
@property NSMutableArray* arrayOfCollection;
@property UIButton* exitButton;
@property UILabel* titleLabel;

@end

NS_ASSUME_NONNULL_END
