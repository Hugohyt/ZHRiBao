//
//  CollectionController.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray* arrayOfCollection;

@end

NS_ASSUME_NONNULL_END
