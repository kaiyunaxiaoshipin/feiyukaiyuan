
#import <UIKit/UIKit.h>

@class chatmessageModel;

@interface chatmessageCell : UITableViewCell

@property(nonatomic,strong)chatmessageModel *model;

+(chatmessageCell *)cellWithTableView:(UITableView *)tableView;

@end
