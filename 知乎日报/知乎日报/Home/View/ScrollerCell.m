//
//  ScrollerCell.m
//  知乎日报
//
//  Created by 胡永泰 on 2024/10/24.
//

#import "ScrollerCell.h"

@implementation ScrollerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:@"ScrollerCell"];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 7, 400);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = NO;
    [self.contentView addGestureRecognizer:self.scrollView.panGestureRecognizer];
    [self.contentView addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(140, 320, 300, 100)];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.userInteractionEnabled = NO;
    [self.contentView addSubview:self.pageControl];
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:200 target:self selector:@selector(next) userInfo:nil repeats:YES];
    }
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    return self;
}

- (void)next {
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX + [UIScreen mainScreen].bounds.size.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat screenWidth = CGRectGetWidth(scrollView.frame);
    CGFloat contentWidth = scrollView.contentSize.width;
    
    CGFloat pageWidth = scrollView.bounds.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth);
    self.pageControl.currentPage = page;
    if (scrollView.contentOffset.x < pageWidth / 2) {
        self.pageControl.currentPage = 4;
    }
    if (scrollView.contentOffset.x > pageWidth / 2 * 11) {
        self.pageControl.currentPage = 0;
    }
    
    if (contentOffsetX >= contentWidth - screenWidth) {
        [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
    } else if (contentOffsetX < screenWidth - scrollView.frame.size.width) {
        [scrollView setContentOffset:CGPointMake(contentWidth - 2 * screenWidth, 0) animated:NO];
        return;
    }
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Page" object:nil userInfo:dictionary];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
        [self.timer invalidate];
        self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(next) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)layoutSubviews {
    self.scrollView.frame = CGRectMake(0, 0, 394, 400);
}

@end
