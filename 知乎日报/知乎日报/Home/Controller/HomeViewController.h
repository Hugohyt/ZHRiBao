//
//  homeViewController.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/22.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "HomeView.h"


NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property HomeModel *homeModel;
@property HomeView *homeView;
@property NSDate *date;
@property NSMutableArray* beforeArray;
@property int page;
@property NSMutableArray *allArray;

@end

NS_ASSUME_NONNULL_END
