//
//  CommentView.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentView : UIView

@property UITableView *tableView;
@property UIImageView *ImageView1;
@property UILabel *CommentCount;
@property UIButton *ExitButton;

@end

NS_ASSUME_NONNULL_END
