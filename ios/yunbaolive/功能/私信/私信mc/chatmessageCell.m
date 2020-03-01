#import "chatmessageCell.h"
#import "chatmessageModel.h"
#import "UIImage+Resize.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@interface chatmessageCell ()
{
    UILabel *_timeL;
    UIButton *_textBTN;
    UIButton *_iconBTN;
}
@end
@implementation chatmessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeL = [[UILabel alloc] init];
        _timeL.textAlignment = NSTextAlignmentCenter;
        _timeL.font = [UIFont systemFontOfSize:4];
        _timeL.textColor = [UIColor lightGrayColor];
        _timeL.font = FNOT;
        _textBTN = [[UIButton alloc] init];
        _textBTN.titleLabel.numberOfLines = 0;
        _textBTN.titleLabel.font = [UIFont systemFontOfSize:16];
        //设置有效的显示范围
        _textBTN.contentEdgeInsets = UIEdgeInsetsMake(10,15,10,15);
        _iconBTN = [[UIButton alloc] init];
        _iconBTN.layer.masksToBounds = YES;
        _iconBTN.layer.cornerRadius = 20;
        [self.contentView addSubview:_timeL];
        [self.contentView addSubview:_textBTN];
        [self.contentView addSubview:_iconBTN];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(void)setModel:(chatmessageModel *)model{
    _model = model;
    //设置数据
    [self setCellData];
    //设置坐标
    [self setCellFrame];
}
-(void)setCellFrame
{
    _textBTN.frame = _model.textR;
    _timeL.frame = _model.timeR;
    _iconBTN.frame = _model.iconR;
}
-(void)setCellData
{
    _timeL.text = _model.time;
    [_textBTN setTitle:_model.text forState:UIControlStateNormal];
    [_iconBTN sd_setImageWithURL:[NSURL URLWithString:_model.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg1"]];
    if ([_model.type isEqual:@"0"]) {
        [_textBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_textBTN setBackgroundImage:[UIImage resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    }
    else
    {
        [_textBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_textBTN setBackgroundImage:[UIImage resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
}
+(chatmessageCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"messageCell";
    chatmessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
         cell = [[chatmessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
@end
