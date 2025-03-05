//
//  CommentViewController.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/4.
//

#import <UIKit/UIKit.h>
#import "ExtraModel.h"
#import "LongCommentsModel.h"
#import "ShortCommentsModel.h"
#import "CommentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSString* id;
@property ExtraModel* extraModel;
@property ShortCommentsModel* shortCommentsModel;
@property LongCommentsModel* longCommentsModel;



@end

NS_ASSUME_NONNULL_END
