//
//  CollectionViewController.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import <UIKit/UIKit.h>
#import "CollectionTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray* arrayOfCollection;
@property CollectionTableView* collectionTableView;

@end

NS_ASSUME_NONNULL_END
