//
//  huanxinsixinview.h
//  yunbaolive
//
//  Created by zqm on 16/8/3.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMListen.h"
#import "chatsmallview.h"
@interface huanxinsixinview : JMListen<UITableViewDataSource,UITableViewDelegate>
{
    NSString *lastMessage;//获取最后一条消息
    chatsmallview *chatView;
    NSString *idStrings;
}
@property(nonatomic,strong)NSMutableArray *allArray;//未关注好友
@property(nonatomic,strong)NSMutableArray *JIMallArray;//所有
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *zhuboID;

-(void)forMessage;

@end
