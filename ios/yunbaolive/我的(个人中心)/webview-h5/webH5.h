//
//  webH5.h
//  yunbaolive
//
//  Created by zqm on 16/5/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webH5 : UIViewController

@property(nonatomic,copy)NSString *isjingpai;//判断是不是竞拍，是的话返回的时候刷新钻石s
@property(nonatomic,strong)NSString *urls;
@property(nonatomic,strong)NSString *titles;
@property (nonatomic,strong) NSString *itemID;


@end
