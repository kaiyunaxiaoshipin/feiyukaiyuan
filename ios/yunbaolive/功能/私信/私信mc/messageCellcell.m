
#import "messageCellcell.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "messageModel.h"
@interface messageCellcell ()
@property (weak, nonatomic) IBOutlet UIButton *iconB;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *messageL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *sexI;
@property (weak, nonatomic) IBOutlet UIImageView *levelI;
@property (weak, nonatomic) IBOutlet UIButton *anReadL;
@end
@implementation messageCellcell
-(void)drawRect:(CGRect)rect{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(47, rect.size.height - 1, _window_width,1)];
    label.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.7];
    [self addSubview:label];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _anReadL.layer.masksToBounds = YES;
      _anReadL.layer.cornerRadius = 10;
    }
    return self;
}
-(void)setModel:(messageModel *)model{
    _model = model;
    [self.iconB sd_setImageWithURL:[NSURL URLWithString:_model.imageIcon]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg1"]];
    _nameL.text = _model.userName;
    _messageL.text = _model.content;
    _timeL.text = _model.time;
    _messageL.text = _model.content;
    if ([_model.sex isEqual:@"1"]) {
        _sexI.image= [ UIImage imageNamed:@"sex_man"];
    }else if ([_model.sex isEqual:@"2"]){
        _sexI.image = [UIImage imageNamed:@"sex_woman"];
    }else{
        _sexI.image= [ UIImage imageNamed:@"sex_woman"];
    }
    NSDictionary *levelDic = [common getUserLevelMessage:_model.level];
    [_levelI sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];

//    NSString *path = [NSString stringWithFormat:@"leve%@",_model.level];
//    _levelI.image = [UIImage imageNamed:path];
    if (![_model.unReadMessage isEqual:@"0"]) {
        _anReadL.hidden = NO;
        [_anReadL setTitle:_model.unReadMessage forState:UIControlStateNormal];
    }
    else{
        _anReadL.hidden = YES;
    }
}
+(messageCellcell *)cellWithTableView:(UITableView *)tableView{
    messageCellcell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"messageCellcell" owner:self options:nil].lastObject;
    }
    return cell;
}
@end
