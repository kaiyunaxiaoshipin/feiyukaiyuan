//
//  MsgSysModel.m
//  iphoneLive
//
//  Created by YunBao on 2018/8/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MsgSysModel.h"

@implementation MsgSysModel

- (instancetype)initWithDic:(NSDictionary *)dic lisModel:(MessageListModel *)listModel{
    self = [super init];
    if (self) {
        
        _idStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
        _uidStr = listModel.uidStr;
        _iconStr = listModel.iconStr;
        _titleStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
        _timeStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"addtime"]];
        
//        if ([listModel.uidStr isEqual:@"dsp_admin_1"]) {
//            _briefStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"synopsis"]];
//            _urlStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"url"]];
//        }
//        if ([listModel.uidStr isEqual:@"dsp_admin_2"]) {
            _contentStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"content"]];
//        }
        //不再预先计算，选用cell自动计算行高(xib布局基本按照下面注释设置的约束)
        //[self setFrame];
    }
    return self;
}
-(void)setFrame {
    
    /** (xib布局基本按照下面注释设置的约束)
     *  top    10
     *  title  20
     *  t-b-space  5
     *  brief  计算
     *  time-brief-space  10
     *  time   16
     *  bot    10
     *  icon   42*42  内容高度>头像
     */
    
}


+(instancetype)modelWithDic:(NSDictionary *)dic lisModel:(MessageListModel *)listModel{
    return [[self alloc]initWithDic:dic lisModel:listModel];
}


@end
