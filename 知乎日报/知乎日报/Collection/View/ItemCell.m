//
//  ItemCell.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import "ItemCell.h"

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.itemLabel = [[UILabel alloc] init];
    self.itemLabel.frame = CGRectMake(20, 10, 80, 30);
    [self.contentView addSubview:self.itemLabel];
    self.selectImageView = [[UIImageView alloc] init];
    self.selectImageView.frame = CGRectMake(340, 10, 30, 30);
    self.selectImageView.image = [UIImage imageNamed:@"选择.jpg"];
    [self.contentView addSubview:self.selectImageView];
    return self;
}

@end
