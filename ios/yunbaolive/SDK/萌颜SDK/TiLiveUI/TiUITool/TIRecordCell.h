//
//  TIRecordCell.h
//  yunbaolive
//
//  Created by IOS1 on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TIRecordCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *seletcImgV;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbTopC;
// 哈哈镜特效
- (void)setDistortionUICellByIndex:(NSInteger)index;
// 切换cell时特效更改
- (void)changeCellEffect:(BOOL)isChange;

@end

NS_ASSUME_NONNULL_END
