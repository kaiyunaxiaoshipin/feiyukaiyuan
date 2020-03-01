
#import <UIKit/UIKit.h>

@class listModel;

@interface listCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageV;

@property(nonatomic,strong)UIImageView *levelimage;

@property(nonatomic,strong)listModel *model;

@property(nonatomic,strong)UIImageView *kuang;

+(listCell *)collectionview:(UICollectionView *)collectionview andIndexpath:(NSIndexPath *)indexpath;


@end
