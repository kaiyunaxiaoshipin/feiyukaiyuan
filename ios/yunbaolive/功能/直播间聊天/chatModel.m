#import "chatModel.h"
#import "NSString+StringSize.h"
@implementation chatModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.titleColor  = minstr([dic valueForKey:@"titleColor"]);
        self.userName = minstr([dic valueForKey:@"userName"]);
        self.contentChat = minstr([dic valueForKey:@"contentChat"]);
        self.levelI = minstr([dic valueForKey:@"levelI"]);
        self.userID = minstr([dic valueForKey:@"id"]);
        self.vip_type = minstr([dic valueForKey:@"vip_type"]);
        self.liangname = minstr([dic valueForKey:@"liangname"]);
        self.guardType = minstr([dic valueForKey:@"guard_type"]);

        if ([minstr([dic valueForKey:@"usertype"]) isEqual:@"40"]) {
            self.isadmin = @"1";
        }else{
            self.isadmin = @"0";
        }
        self.isAnchor = minstr([dic valueForKey:@"isAnchor"]);
    }
    return self;
}
-(void)setChatFrame:(chatModel *)upChat{
    UIFont *font1 = [UIFont fontWithName:@"Microsoft YaHei"size:15];//Arial-ItalicMT
    NSString *string = [_userName stringByAppendingPathComponent:_contentChat];
    //VIP类型，0表示无VIP，1表示普通VIP，2表示至尊VIP
    //0表示无靓号
    if ([self.vip_type isEqual:@"0"] ||self.vip_type == nil || self.vip_type == NULL || [self.vip_type isEqual:@"(null)"])
    {
        _vipR = CGRectMake(2, 0, 0, 0);
    }
    else
    {
        _vipR = CGRectMake(2,0,25,25);
    }
    if ([self.liangname isEqual:@"0"])
    {
        _liangR = CGRectMake(2,0,0,0);
    }
    else
    {
        _liangR = CGRectMake(_vipR.size.width + 2,5,16,16);
    }
//    CGFloat ww ;
//    if (IS_IPHONE_5) {
//        ww = _window_width*0.45 + 70;
//    }else{
//        ww = _window_width*0.55 + 70;
//    }
//    CGSize size = [string boundingRectWithSize:CGSizeMake(ww, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font1} context:nil].size;
    _levelR = CGRectMake(_liangR.size.width + _vipR.size.width + 6,7,16,16);
//    double suanheight = ceil(size.height);
    CGFloat widthhh = tableWidth - (_liangR.size.width + _vipR.size.width + 6+16)-2;
    double suanheight = [[YBToolClass sharedInstance] heightOfString:string andFont:font1 andWidth:widthhh];
    _nameR  = CGRectMake(_levelR.origin.x + _levelR.size.width + 6,3,widthhh,suanheight);//+30
    _NAMER = CGRectMake(2,3, tableWidth-4, suanheight);
    _rowHH = MAX(0, CGRectGetMaxY(_nameR));
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    chatModel *model = [[chatModel alloc]initWithDic:dic];
    return model;
}
@end
