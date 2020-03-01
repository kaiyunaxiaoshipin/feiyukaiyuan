#import "messageModel.h"
@implementation messageModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userName        = [NSString stringWithFormat:@"%@",[dic valueForKey:@"user_nicename"]];
        self.imageIcon       = [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar"]];
        self.level           = [NSString stringWithFormat:@"%@",[dic valueForKey:@"level"]];
        self.sex             = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sex"]];
        self.uid             = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
        self.conversations   = [dic valueForKey:@"conversation"];
        self.time            = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%@",self.conversations.latestMsgTime]];
        JMSGMessage *message = self.conversations.latestMessage;
        self.content         = [message.content valueForKey:@"text"];
        self.unReadMessage   = [NSString stringWithFormat:@"%@",self.conversations.unreadCount];
    }
    return  self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
