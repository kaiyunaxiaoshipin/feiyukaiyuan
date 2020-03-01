//
//  LookVideo1.h
//  iphoneLive
//
//  Created by Rookie on 2018/7/9.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^scrollBlock)(NSMutableArray *array,NSInteger page,NSInteger index);


@interface LookVideo : UIViewController


@property(nonatomic,copy)scrollBlock block;
@property(nonatomic,strong)NSDictionary *lastHostDic;      //上一个
@property(nonatomic,strong)NSDictionary *hostdic;          //当前
@property(nonatomic,strong)NSDictionary *nextHostDic;      //下一个
@property(nonatomic,assign) NSInteger curentIndex;         //页面传值
@property(nonatomic,strong)NSMutableArray *videoList;
@property (nonatomic,assign) NSInteger pages;
@property (nonatomic,strong) NSString *requestUrl;
@property (nonatomic,strong) NSString *fromWhere;

@property (nonatomic,strong) UIImage *firstPlaceImage;

@end
