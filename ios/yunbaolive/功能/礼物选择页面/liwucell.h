
#import <UIKit/UIKit.h>

#import "liwuModel.h"

#import "LivePlay.h"


@interface liwucell : UICollectionViewCell
{
    UIImageView *imageView;
    
    moviePlay *player;
}


@property(nonatomic,strong)UIButton *imageVs;

@property(nonatomic,strong)UIButton *duihao;

@property(nonatomic,strong)UIImageView *cellimageV;

@property(nonatomic,strong)UIImageView *kuangimage;

@property(nonatomic,strong)UILabel *priceL;

@property(nonatomic,strong)UILabel *countL;

@property(nonatomic,strong)liwuModel *model;


@end
