//
//  SlideCollectionViewCell.h
//  JR-Player
//
//  Created by 王潇 on 16/3/10.
//  Copyright © 2016年 王潇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SlideModel : NSObject

@property (nonatomic, strong) UIImage	*image;
@property (nonatomic, assign) CMTime	time;
- (instancetype)initWithImage:(UIImage *)image time:(CMTime)time;

@end


@interface SlideCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) SlideModel	*model;
@property (nonatomic, strong) NSString		*timeString;
@end
