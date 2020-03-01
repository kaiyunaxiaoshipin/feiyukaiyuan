
#import <UIKit/UIKit.h>

#import "MJRefresh.h"

#import "ZYTabBar.h"


@interface Hotpage : UIViewController
//筛选省份  性别。。
@property(nonatomic,copy,nonnull)NSString *province;
@property(nonatomic,copy,nonnull)NSString *sex;
@property(nonatomic,copy,nonnull)NSString *biaoji;
@property(nonatomic,copy,nonnull)NSString *zhuboTitle;
@property(nonatomic,strong,nonnull) UILabel *label;
@property(nonatomic,copy,nonnull)NSString *url;
@property (nonatomic,strong,nonnull)UIView *pageView;

@end
