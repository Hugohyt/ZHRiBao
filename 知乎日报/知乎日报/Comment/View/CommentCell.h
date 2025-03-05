//
//  CommentCell.h
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/7.
//

#import <UIKit/UIKit.h>
#import "ShortCommentsSubModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^OpenCloseBlock)(void);

@interface CommentCell : UITableViewCell <UITextViewDelegate>

@property UIImageView* nameIcon;
@property UILabel* nameLabel;
@property UIButton* likeButton;
@property UIButton* commentButton;
@property UIImageView* moreButtonView;
@property UILabel* likes;
@property UILabel* timeLabel;
@property UILabel* contentLabel;
@property UITextView* replyTextView;
@property OpenCloseBlock openCloseBlock;

- (void)setupCellShortCommentsDate:(ShortCommentsSubModel*)model;

@end

NS_ASSUME_NONNULL_END
