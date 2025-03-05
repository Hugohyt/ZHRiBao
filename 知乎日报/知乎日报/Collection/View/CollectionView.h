//
//  CollectionView.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionView : UIView 
@property NSMutableArray *arrayOfCollection;
@property UITableView* tableView;
@property UIButton* exitButton;

@end

NS_ASSUME_NONNULL_END
