//
//  IconCel.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/11/17.
//

#import "IconCell.h"

@implementation IconCell;

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
    self.iconView = [[UIImageView alloc] init];
    self.iconView.frame = CGRectMake(161, 40, 70, 70);
    self.iconView.layer.cornerRadius = 35;
    self.iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.nameLabel setFont:[UIFont systemFontOfSize:20]];
    self.nameLabel.frame = CGRectMake(146, 120, 100, 30);
    [self.contentView addSubview:self.nameLabel];
    
    return self;
}


@end
