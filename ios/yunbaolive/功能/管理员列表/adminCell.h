

#import <UIKit/UIKit.h>
@class fansModel;
@protocol adminCellDelegate <NSObject>
- (void)delateAdminUser:(fansModel *)model;
@end

@interface adminCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *iconBTN;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UIImageView *sexL;

@property (weak, nonatomic) IBOutlet UIImageView *levelL;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property(nonatomic,weak)id <adminCellDelegate> delegate;


@property(nonatomic,strong)fansModel *model;

+(adminCell *)cellWithTableView:(UITableView *)tableView;

@end
