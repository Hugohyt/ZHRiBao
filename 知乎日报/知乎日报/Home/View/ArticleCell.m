//
//  ArticleCell.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/24.
//

#import "ArticleCell.h"
#import "Masonry.h"

@implementation ArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //属性初始化
    self.imageView1 = [[UIImageView alloc] init];
    self.label = [[UILabel alloc] init];
    self.writerLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.imageView1];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.writerLabel];
    
    return self;
}

- (void)layoutSubviews {
//    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
//        make.left.mas_equalTo(294);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(80);
//    }];
    self.imageView1.frame = CGRectMake(294, 20, 80, 80);
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
//        make.left.mas_equalTo(10);
//        make.width.mas_equalTo(274);
//        make.height.mas_equalTo(60);
//    }];
    self.label.frame = CGRectMake(10, 20, 274, 60);
    [self.label setFont:[UIFont systemFontOfSize:18]];
    self.label.numberOfLines = 2;
    [self.label layoutIfNeeded];
//    [self.writerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(70);
//        make.left.mas_equalTo(10);
//        make.width.mas_equalTo(364);
//        make.height.mas_equalTo(20);
//    }];
    self.writerLabel.frame = CGRectMake(10, 70, 364, 20);
    [self.writerLabel setFont:[UIFont systemFontOfSize:12]];
    [self.writerLabel setTextColor:[UIColor grayColor]];
}


@end
