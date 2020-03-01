#import "MXTabCell.h"
@interface MXTabCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@end
@implementation MXTabCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (void)addTabTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:14];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 15;
    _titleLabel = titleLabel;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = self.contentView.bounds;
}

@end
