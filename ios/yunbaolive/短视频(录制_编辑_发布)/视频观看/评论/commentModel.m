//
//  commentModel.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "commentModel.h"

@implementation commentModel
-(instancetype)initWithDic:(NSDictionary *)subdic{
    self = [super init];
    if (self) {
        _at_info = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"at_info"]];
        _avatar_thumb = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"avatar"]];
        _user_nicename = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]];
        _content = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"content"]];
        _datetime = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"datetime"]];
        _likes = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"likes"]];
        _islike = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"islike"]];
        _replys = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"replys"]];
        _commentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"commentid"]];
        _parentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        _ID = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"id"]];
        _replyList = [subdic valueForKey:@"replylist"];
        if ([_replys intValue] > 0) {
            NSDictionary *rrrDic = [[subdic valueForKey:@"replylist"] firstObject];
            _replyDate = minstr([rrrDic valueForKey:@"datetime"]);
            _replyName = minstr([[rrrDic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]);
            _replyContent = minstr([rrrDic valueForKey:@"content"]);
        }
    }
    return self;
}
-(void)setmyframe:(commentModel *)model{
    NSString *str = [NSString stringWithFormat:@"%@ %@",_content,_datetime];
    CGSize size = [str boundingRectWithSize:CGSizeMake(_window_width - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    NSString *str2 = [NSString stringWithFormat:@"%@ %@",_replyContent,_replyDate];
    CGSize size2 = [str2 boundingRectWithSize:CGSizeMake(_window_width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;

    _contentRect = CGRectMake(50,45, size.width, size.height);
    
    _ReplyFirstRect = CGRectMake(70, _contentRect.origin.y + _contentRect.size.height + 20, size2.width, size2.height);
    int replys = [_replys intValue];
    if (replys >1) {
        _ReplyRect = CGRectMake(50, _ReplyFirstRect.origin.y + _ReplyFirstRect.size.height + 5, _window_width - 100,20);
         _rowH = MAX(0, CGRectGetMaxY(_ReplyRect)) + 5;
    }else{
        if (replys == 1) {
            _rowH = MAX(0, CGRectGetMaxY(_ReplyFirstRect)) + 15;
        }else{
            _rowH = MAX(0, CGRectGetMaxY(_contentRect)) + 15;
        }
        _ReplyRect = CGRectMake(0, 0, 0, 0);
    }
}
+(instancetype)modelWithDic:(NSDictionary *)subdic{
    commentModel *model = [[commentModel alloc]initWithDic:subdic];
    return model;
}
@end
