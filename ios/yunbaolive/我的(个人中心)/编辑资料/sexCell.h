
#import <UIKit/UIKit.h>

@interface sexCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

+(sexCell *)cellWithTableView:(UITableView *)tableView;

@end
