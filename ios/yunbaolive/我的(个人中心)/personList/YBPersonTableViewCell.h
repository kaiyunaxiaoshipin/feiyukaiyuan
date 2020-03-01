
#import <UIKit/UIKit.h>
@class YBPersonTableViewModel;

@protocol personInfoCellDelegate <NSObject>

-(void)pushEditView;
-(void)pushLiveNodeList;
-(void)pushAttentionList;
-(void)pushFansList;

@end

@interface YBPersonTableViewCell : UITableViewCell

@property(nonatomic,strong)YBPersonTableViewModel *model;
//跳页面代理
@property(nonatomic,assign)id<personInfoCellDelegate>personCellDelegate;
/**
 *  个人中心个人信息cell
 */

@property(nonatomic,strong) UIView *centerView;//用来居中名称，性别，等级,编辑图标

//头像视图
@property (nonatomic, weak) UIImageView *iconView;

//姓名
@property (nonatomic, weak) UILabel *nameLabel;
//性别
@property (nonatomic, weak) UIImageView *sexView;
//等级
@property (nonatomic, weak) UIImageView *levelView;
//主播等级
@property (nonatomic, weak) UIImageView *level_anchorView;
//编辑按钮
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *editBtn2;
//签名
@property (nonatomic, strong) UILabel *IDL;

//底部view

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

@end
