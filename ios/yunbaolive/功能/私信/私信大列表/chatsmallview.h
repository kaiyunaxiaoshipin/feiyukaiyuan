

#import <UIKit/UIKit.h>
#import "JMListen.h"


@interface chatsmallview : JMListen<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIView *mview;
    NSString *content;
    UILabel *labell;
    UIView *backview;
    UIView *zhezhao;
    UIView *navtion;
    UIButton *send;
    int sendok;
    CGFloat barH;
}
@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,assign)int bakcOK;//判断返回
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)UITextField *textField;
@property (nonatomic) NSTimeInterval messageTimeIntervalTag;
@property (nonatomic) NSInteger messageCountOfPage; //default 50
@property(nonatomic,strong)NSString *chatID;
@property(nonatomic,strong)NSString *chatname;
@property(nonatomic,strong)NSString *icon;
/**
 是否可以发消息
 */
@property (nonatomic,strong) NSString *fromWhere;
-(void)getnew;
@property(nonatomic,strong)JMSGConversation *msgConversation;
-(void)changename;
-(void)formessage;
@end
