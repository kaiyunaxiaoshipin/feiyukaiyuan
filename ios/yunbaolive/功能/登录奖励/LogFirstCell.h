//
//  LogFirstCell.h
//  yunbaolive
//
//  Created by Rookie on 2017/4/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogFirstCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgIV2;     //当天旋转背景
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;      //底层背景
@property (weak, nonatomic) IBOutlet UILabel *titleL;        //标题
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;   //中间钻石
@property (weak, nonatomic) IBOutlet UILabel *numL;          //奖励


@end
