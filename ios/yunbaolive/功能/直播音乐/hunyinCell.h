

#import <UIKit/UIKit.h>
@class hunyinModel;
@interface hunyinCell : UITableViewCell

@property(nonatomic,copy)NSString *songID;

@property (weak, nonatomic) IBOutlet UILabel *song;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property(nonatomic,strong)hunyinModel *model;

@property (weak, nonatomic) IBOutlet UIButton *down;


@property (nonatomic,copy) NSString *path;
@property(nonatomic,copy)  NSString *songName;
@property(nonatomic,strong)  NSString *paths;



- (IBAction)download:(id)sender;



@property(nonatomic,strong)UILabel *nameL;

@property(nonatomic,strong)UILabel *songL;

@property(nonatomic,strong)UIButton *downBTN;

@property(nonatomic,strong)UILabel *downL;

@property(nonatomic,assign)BOOL isDown;

+(hunyinCell *)cellWithTableView:(UITableView *)tableView;
-(void)musicDownLoad;

@end
