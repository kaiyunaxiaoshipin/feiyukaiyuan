#import <UIKit/UIKit.h>
@class hotModel;
@interface hotCell : UITableViewCell
@property(nonatomic,strong)UIImageView *IconBTN;//主播头像
@property(nonatomic,strong)UILabel *nameL;//主播名字
@property(nonatomic,strong)UITextField *placeL;//主播位置
@property(nonatomic,strong)UITextField *peopleCountL;//在线人数
@property(nonatomic,strong)UIImageView *imageV;//显示大图
@property(nonatomic,strong)UIImageView *statusimage;//直播状态
@property(nonatomic,strong)UIView *myView;//地步view
@property(nonatomic,strong)UILabel *titleLabel;//直播标题

@property(nonatomic,strong)UIImageView *level_anchormage;//主播等级
@property(nonatomic,strong)UIImageView *typeimagevc;//直播类型
@property(nonatomic,strong)UIImageView *gameimagevc;//游戏类型
@property(nonatomic,strong)hotModel *model;
+(hotCell *)cellWithTableView:(UITableView *)tableView;
@end
