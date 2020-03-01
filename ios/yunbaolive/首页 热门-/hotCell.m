#import "hotCell.h"
#import "hotModel.h"
#import "UIImageView+WebCache.h"
@implementation hotCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
            self.backgroundColor = [UIColor colorWithRed:237/255.0 green:245/255.0 blue:244/255.0 alpha:1];
            self.myView = [[UIView alloc]initWithFrame:CGRectMake(0,0,_window_width,60)];
            self.myView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:self.myView];
            //创建主播头像button
            self.IconBTN = [[UIImageView alloc]init];
            self.IconBTN.layer.masksToBounds = YES;
            self.IconBTN.layer.cornerRadius = 20;
            //创建显示大图
            self.imageV = [[UIImageView alloc]init];
            [self.imageV setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"无结果"]]];
            //创建名字          Heiti SC
            self.nameL = [[UILabel alloc]init];
            self.nameL.textColor = [UIColor blackColor];
            self.nameL.font = [UIFont fontWithName:@"Heiti SC" size:16];
            //位置(uitextfield)
            UIImageView *imaghevIEW = [[UIImageView alloc]initWithFrame:CGRectMake(50,25,12,13)];
            imaghevIEW.image = [UIImage imageNamed:@"icon_live_location_active.png"];
            imaghevIEW.contentMode = UIViewContentModeScaleAspectFit;
            [self.myView addSubview:imaghevIEW];
            self.placeL = [[UITextField alloc]init];
            self.placeL.font = [UIFont fontWithName:@"Heiti SC" size:13];
            self.placeL.textColor = [UIColor lightGrayColor];
            self.placeL.userInteractionEnabled = NO;
            self.placeL.leftViewMode = UITextFieldViewModeAlways;
            self.placeL.leftView = imaghevIEW;
            //在线人数
            self.peopleCountL = [[UITextField alloc]init];
            self.peopleCountL.font = [UIFont fontWithName:@"Heiti SC" size:16];
            self.peopleCountL.textAlignment = NSTextAlignmentRight;
            self.peopleCountL.textColor = [UIColor lightGrayColor];
            self.peopleCountL.enabled = NO;
            self.peopleCountL.rightViewMode = UITextFieldViewModeAlways;
//            UILabel *onlabel = [[UILabel alloc]initWithFrame:CGRectMake(_window_width-95,30 ,80,20)];
//            onlabel.textColor = [UIColor lightGrayColor];
//            onlabel.textAlignment = NSTextAlignmentRight;
//            onlabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
//            onlabel.text = @"在看";
            //直播状态
            self.statusimage = [[UIImageView alloc]init];
            self.statusimage.image = [UIImage imageNamed:@"直播live"];
            self.statusimage.contentMode = UIViewContentModeScaleAspectFit;
            _level_anchormage = [[UIImageView alloc]initWithFrame:CGRectMake(38,38, 16, 16)];
            _level_anchormage.layer.masksToBounds = YES;
            _level_anchormage.layer.cornerRadius = 8;
       
             //开播类型
             _typeimagevc = [[UIImageView alloc]initWithFrame:CGRectMake(15,20,60,60)];
             _typeimagevc.contentMode = UIViewContentModeScaleAspectFit;
             [_typeimagevc setImage:[UIImage imageNamed:@"普通"]];
             _typeimagevc.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
             _gameimagevc = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width - 120,_window_width - 120,120,120)];
             _gameimagevc.contentMode = UIViewContentModeScaleAspectFit;
             _gameimagevc.hidden = YES;
        
        
        
            // [self.myView addSubview:onlabel];
             [self.imageV addSubview:self.statusimage];
             [self.myView addSubview:self.peopleCountL];
             [self.myView addSubview:self.placeL];
             [self.myView addSubview:self.nameL];
             [self.myView addSubview:self.IconBTN];
             [self addSubview:_level_anchormage];
             [self.imageV addSubview:_typeimagevc];
             [self.imageV addSubview:_gameimagevc];
             [self.contentView addSubview:self.imageV];
             self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _window_width+40, _window_width,20)];
             self.titleLabel.textColor = [UIColor whiteColor];
             self.titleLabel.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
             self.titleLabel.font = fontThin(14);
             [self.contentView addSubview:self.titleLabel];
        
        }
    return self;
}
-(void)setModel:(hotModel *)model{
    _model = model;
    self.nameL.text = _model.zhuboName;
    if (_model.title == NULL || _model.title == nil || _model.title.length == 0) {
        self.titleLabel.hidden = YES;
    }
    else{
        self.titleLabel.hidden = NO;
        self.titleLabel.text = [NSString stringWithFormat:@"   %@",_model.title];
    }
    NSString *imagePath = [_model.zhuboIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.IconBTN sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"bg1"]];
    NSString *thumb = [NSString stringWithFormat:@"%@",_model.zhuboImage];
    if (thumb) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:[UIImage imageNamed:@"无结果"]];
    }
    [_level_anchormage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",_model.level_anchor]]];
    self.placeL.text = [NSString stringWithFormat:@"%@%@",@" ",_model.zhuboPlace];
    self.peopleCountL.text = [NSString stringWithFormat:@"%@%@",_model.onlineCount,YZMsg(@"在看")];
    self.IconBTN.frame = _model.IconR;
    self.imageV.frame = _model.imageR;
    self.nameL.frame = _model.nameR;
    self.statusimage.frame = _model.statusR;
    self.peopleCountL.frame = _model.CountR;
    self.placeL.frame = _model.placeR;
    int type = [minstr(_model.type) intValue];
    //0是一般直播，1是私密直播，2是收费直播，3是计时直播
    switch (type) {
        case 0:
            [_typeimagevc setImage:[UIImage imageNamed:@"普通"]];
            break;
        case 1:
            [_typeimagevc setImage:[UIImage imageNamed:@"密码"]];
            break;
        case 2:
            [_typeimagevc setImage:[UIImage imageNamed:@"付费"]];
            break;
        case 3:
            [_typeimagevc setImage:[UIImage imageNamed:@"计时"]];
            break;
        default:
            break;
    }
    //1炸金花  2海盗  3转盘  4牛牛  5二八贝
    int gametype = [minstr(_model.game_action) intValue];
    switch (gametype) {
        case 0:
            _gameimagevc.hidden = YES;
            break;
        case 1:
            _gameimagevc.hidden = NO;
            [_gameimagevc setImage:[UIImage imageNamed:@"三张list"]];
            _gameimagevc.frame = CGRectMake(_window_width - 140,_window_width - 140,140,140);
            break;
        case 2:
            _gameimagevc.hidden = NO;
            [_gameimagevc setImage:[UIImage imageNamed:@"海盗list"]];
            _gameimagevc.frame = CGRectMake(_window_width - 140,_window_width - 140,140,140);
            break;
        case 3:
            _gameimagevc.hidden = NO;
            [_gameimagevc setImage:[UIImage imageNamed:@"转盘list"]];
            _gameimagevc.frame = CGRectMake(_window_width - 80,_window_width - 100,80,80);
            break;
        case 4:
            _gameimagevc.hidden = NO;
            [_gameimagevc setImage:[UIImage imageNamed:@"牛牛list"]];
            _gameimagevc.frame = CGRectMake(_window_width - 140,_window_width - 140,140,140);
            break;
        case 5:
            _gameimagevc.hidden = NO;
            [_gameimagevc setImage:[UIImage imageNamed:@"二八贝list2"]];
            _gameimagevc.frame = CGRectMake(_window_width - 120,_window_width - 120,120,120);
            break;
        default:
            break;
    }
}
+(hotCell *)cellWithTableView:(UITableView *)tableView{
    hotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    if (!cell) {
        cell = [[hotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
    }
    return cell;
}
@end
