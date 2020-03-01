//
//  homepageController.h
//  TYPagerControllerDemo
//
//  Created by tany on 16/5/17.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "TYPageView/MXTabBtnPagC.h"
@interface homepageController : MXTabBtnPagC
{
    int unRead;//未读消息
    int sendMessage;
  //  EMConversation *em;//会话id;
    UILabel *label;
    
}
@property(nonatomic,strong)NSArray *conversations;//获取会话列表

@property (nonatomic, assign) BOOL showNavBar;

/**
 *列表排序
 */
@property(nonatomic,assign)NSInteger orderno;

@property(nonatomic,copy)NSString *paths;

@end
