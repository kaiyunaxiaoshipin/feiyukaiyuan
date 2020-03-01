//
//  VideoCollectionCell.h
//  iphoneLive
//
//  Created by YangBiao on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NearbyVideoModel.h"
@interface VideoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,strong) NearbyVideoModel *model;
@property (nonatomic,copy) NSString *isAtten;   //是不是关注页面使用,如果是的话原来的定位图标、label显示时间
@property (nonatomic,copy) NSString *isList;    //是不是首页视频列表，如果是的话定位图标、label显示评论数，右上角添加定位view

@end
