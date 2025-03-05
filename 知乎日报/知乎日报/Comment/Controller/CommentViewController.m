//
//  CommentViewController.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/4.
//

#import "CommentViewController.h"
#import "CommentView.h"
#import "Manager.h"
#import "YYModel.h"
#import "CommentCell.h"
#import "LongCommentsSubModel.h"
#import "SDWebImage.h"
#import "ShortCommentsSubModel.h"
#import "Masonry.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    dispatch_group_t group = dispatch_group_create();
    Manager *manager = [Manager shareManeger];
    
    // 进行网络请求
    dispatch_group_enter(group);
    [manager NetWorkGetFor:self.id WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
        if (!error) {
            self.extraModel = [ExtraModel yy_modelWithDictionary:userData];
            [manager NetWorkGetLongComentsFor:self.id WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
                if (!error) {
                    self.longCommentsModel = [LongCommentsModel yy_modelWithDictionary:userData];
                    [manager NetWorkGetShortComentsFor:self.id WithCompletion:^(NSDictionary * _Nonnull userData, NSError * _Nonnull error) {
                        if (!error) {
                            self.shortCommentsModel = [ShortCommentsModel yy_modelWithDictionary:userData];
                        }
                        dispatch_group_leave(group); // 这个需要在所有请求的最后调用
                    }];
                }
            }];
        }
    }];
    // 确保所有请求和图片加载完成后才更新 UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 在这里进行视图更新
//        NSLog(@"%@, %@, %@",[self.extraModel yy_modelToJSONObject], [self.longCommentsModel yy_modelToJSONObject], [self.shortCommentsModel yy_modelToJSONObject]);
        [self loadTableView];
    });
}

- (void)loadTableView {
    CommentView* commentView = [[CommentView alloc] init];
    commentView.frame = self.view.frame;
    [commentView.ExitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    commentView.CommentCount.text = [NSString stringWithFormat:@"%d条评论",self.extraModel.comments];
    
    commentView.tableView.delegate = self;
    commentView.tableView.dataSource = self;
    commentView.tableView.estimatedRowHeight = 400;
    commentView.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    commentView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:commentView];
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"1");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.longCommentsModel.comments.count == 0 && self.shortCommentsModel.comments.count == 0) {
        return 0;
    } else if (self.longCommentsModel.comments.count != 0 && self.shortCommentsModel.comments.count == 0) {
        return 1;
    } else if (self.longCommentsModel.comments.count == 0 && self.shortCommentsModel.comments.count != 0) {
        return 1;
    } else  {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"zhixingle");
    if (section == 0 && self.longCommentsModel.comments.count != 0) {
        return self.longCommentsModel.comments.count;
    } else {
        NSLog(@"zhelizheli");
        NSLog(@"%d",self.shortCommentsModel.comments.count);
        return self.shortCommentsModel.comments.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"liang:%d",tableView.numberOfSections);
    NSLog(@"%d %d",indexPath.section, self.longCommentsModel.comments.count);
    if (indexPath.section == 0 && self.longCommentsModel.comments.count != 0) {
        CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        LongCommentsSubModel *longCommentsSubModel = self.longCommentsModel.comments[indexPath.row];
        NSString* nameIcon = longCommentsSubModel.avatar;
        NSURL* url = [NSURL URLWithString:nameIcon];
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!error) {
                commentCell.nameIcon.image = image;
            } else {
                NSLog(@"图片加载失败");
            }
        }];
        NSLog(@"这到了");
        commentCell.nameLabel.text = longCommentsSubModel.author;
        commentCell.contentLabel.text = longCommentsSubModel.content;
        commentCell.moreButtonView.image = [UIImage imageNamed:@"知乎日报更多.jpg"];
        [commentCell.likes setText:longCommentsSubModel.likes];
        [commentCell.likes setTextColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1]];
        NSTimeInterval timeStamp = [longCommentsSubModel.time doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate* currentDate = [NSDate date];
        NSString* currentDateString = [formatter stringFromDate:currentDate];
        NSString *formattedDate = [formatter stringFromDate:date];
        NSArray* dateComponents = [formattedDate componentsSeparatedByString:@"-"];
        NSArray* currentDateComponents = [currentDateString componentsSeparatedByString:@"-"];
        NSInteger day = [[dateComponents objectAtIndex:2] integerValue];
        NSInteger month = [[dateComponents objectAtIndex:1] integerValue];
        NSInteger year = [[dateComponents objectAtIndex:0] integerValue];
        NSInteger currentDay = [[currentDateComponents objectAtIndex:2] integerValue];
        NSInteger currentMonth = [[currentDateComponents objectAtIndex:1] integerValue];
        NSInteger currentYear = [[currentDateComponents objectAtIndex:0] integerValue];
        if (day == currentDay && month == currentMonth && year == currentYear) {
            formatter.dateFormat = @"今天HH:mm";
            formattedDate = [formatter stringFromDate:date];
        } else {
            formatter.dateFormat = @"MM-dd HH:mm";
            formattedDate = [formatter stringFromDate:date];
        }
        [commentCell.timeLabel setText: formattedDate];
        NSLog(@"到了");
        [commentCell layoutIfNeeded];
        return commentCell;
    } else {
        CommentCell* commentCell = [tableView cellForRowAtIndexPath:indexPath];
        if (commentCell == nil) {
            commentCell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentsCell"];
        }
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        ShortCommentsSubModel *shortCommentsSubModel = self.shortCommentsModel.comments[indexPath.row];
        NSLog(@"isOpen:%d",shortCommentsSubModel.isOpen);
        [shortCommentsSubModel calculate:shortCommentsSubModel.reply_to[@"content"]];
        NSString* nameIcon = shortCommentsSubModel.avatar;
        NSURL* url = [NSURL URLWithString:nameIcon];
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!error) {
                commentCell.nameIcon.image = image;
            } else {
                NSLog(@"图片加载失败");
            }
        }];
        commentCell.nameLabel.text = shortCommentsSubModel.author;
        commentCell.contentLabel.text = shortCommentsSubModel.content;
        commentCell.moreButtonView.image = [UIImage imageNamed:@"知乎日报更多.jpg"];
        [commentCell.likes setText:shortCommentsSubModel.likes];
        [commentCell.likes setTextColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1]];
        if (shortCommentsSubModel.reply_to != NULL) {
            [commentCell setupCellShortCommentsDate:shortCommentsSubModel];
            
            [commentCell setOpenCloseBlock:^{
                shortCommentsSubModel.isOpen = !shortCommentsSubModel.isOpen;
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
            }];
        } else {
            [commentCell.replyTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
        NSTimeInterval timeStamp = [shortCommentsSubModel.time doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate* currentDate = [NSDate date];
        NSString* currentDateString = [formatter stringFromDate:currentDate];
        NSString *formattedDate = [formatter stringFromDate:date];
        NSArray* dateComponents = [formattedDate componentsSeparatedByString:@"-"];
        NSArray* currentDateComponents = [currentDateString componentsSeparatedByString:@"-"];
        NSInteger day = [[dateComponents objectAtIndex:2] integerValue];
        NSInteger month = [[dateComponents objectAtIndex:1] integerValue];
        NSInteger year = [[dateComponents objectAtIndex:0] integerValue];
        NSInteger currentDay = [[currentDateComponents objectAtIndex:2] integerValue];
        NSInteger currentMonth = [[currentDateComponents objectAtIndex:1] integerValue];
        NSInteger currentYear = [[currentDateComponents objectAtIndex:0] integerValue];
        if (day == currentDay && month == currentMonth && year == currentYear) {
            formatter.dateFormat = @"今天HH:mm";
            formattedDate = [formatter stringFromDate:date];
        } else {
            formatter.dateFormat = @"MM-dd HH:mm";
            formattedDate = [formatter stringFromDate:date];
        }
        [commentCell.timeLabel setText: formattedDate];
        
        NSLog(@"到了");
        [commentCell layoutIfNeeded];
        return commentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    if (section == 0 && self.longCommentsModel.comments.count != 0) {
        [label setText:[NSString stringWithFormat:@"%lu条长评",self.longCommentsModel.comments.count]];
    } else {
        [label setText:[NSString stringWithFormat:@"%lu条短评",self.shortCommentsModel.comments.count]];
    }
    [imageView addSubview:label];
    return imageView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
