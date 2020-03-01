//
//  commCell.h
//  yunbaolive
//
//  Created by Boom on 2018/12/17.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"
@protocol commCellDelegate <NSObject>

-(void)pushDetails:(NSDictionary *)commentdic;//跳回复列表

-(void)makeLikeRloadList:(NSString *)commectid andLikes:(NSString *)likes islike:(NSString *)islike;
- (void)reloadCurCell:(commentModel *)model andIndex:(NSIndexPath *)curIndex andReplist:(NSArray *)list;

@end

NS_ASSUME_NONNULL_BEGIN

@interface commCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *zanNumL;
@property (weak, nonatomic) IBOutlet UITableView *replyTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property(nonatomic,strong)NSMutableArray *replyArray;
@property(nonatomic,strong)UIButton *Reply_Button;//回复
@property(nonatomic,strong)UIView *replyBottomView;//回复

@property(nonatomic,strong)NSIndexPath *curIndex;//回复
@property (nonatomic,assign) BOOL isNoMore;//判断是不是没有更多了
@property(nonatomic,strong)commentModel *model;
@property(nonatomic,assign)id<commCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
