#import "hotModel.h"
@implementation hotModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.zhuboName = minstr([dic valueForKey:@"user_nicename"]);
        self.zhuboPlace = minstr([dic valueForKey:@"city"]);
        self.onlineCount = [NSString stringWithFormat:@"%@",[dic valueForKey:@"nums"]];
        self.avatar_thumb = [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar_thumb"]];
        self.zhuboImage = minstr([dic valueForKey:@"thumb"]);
        self.zhuboIcon = minstr([dic valueForKey:@"avatar"]);
        self.zhuboID = minstr([dic valueForKey:@"uid"]);
        self.title = minstr([dic valueForKey:@"title"]);
        self.level_anchor = minstr([dic valueForKey:@"level_anchor"]);
        self.type = minstr([dic valueForKey:@"type"]);
        self.game_action = minstr([dic valueForKey:@"game_action"]);
        self.distance = minstr([dic valueForKey:@"distance"]);

//        [self setCommentFrame];
    }
    return self;
}
-(void)setCommentFrame{
    //头像
    self.IconR = CGRectMake(15,10,40,40);
    //大图
    self.imageR = CGRectMake(0,60, _window_width,_window_width);
    //名字
    self.nameR = CGRectMake(70,10,200, 20);
    //位置
    self.placeR = CGRectMake(70,33,200,14);
    //在线人数
    self.CountR = CGRectMake(_window_width - 170,10,150,20);
    //直播状态
    self.statusR = CGRectMake(_window_width - 95,15,80,45);
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return  [[self alloc]initWithDic:dic];
}
@end
