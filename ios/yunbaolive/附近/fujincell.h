//
//  fujincell.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/13.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fujincell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbimagev;

@property (weak, nonatomic) IBOutlet UIImageView *typeimagev;

@property (weak, nonatomic) IBOutlet UILabel *namel;
@property (weak, nonatomic) IBOutlet UILabel *cityl;

@property (weak, nonatomic) IBOutlet UILabel *distanceL;


@end
