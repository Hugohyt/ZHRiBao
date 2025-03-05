//
//  CollectionArtcleCell.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import "CollectionArtcleCell.h"

@interface CollectionArtcleCell ()

@end

@implementation CollectionArtcleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.nameImageView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"你好";
    self.nameImageView.frame = CGRectMake(294, 10, 80, 80);
    self.nameLabel.frame = CGRectMake(10, 20, 274, 60);
    [self.nameLabel setFont:[UIFont systemFontOfSize:18]];
    self.nameLabel.numberOfLines = 2;
    [self.nameLabel layoutIfNeeded];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.nameImageView];
    NSLog(@"naxie:%@",self.contentView.subviews);
    return self;
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
