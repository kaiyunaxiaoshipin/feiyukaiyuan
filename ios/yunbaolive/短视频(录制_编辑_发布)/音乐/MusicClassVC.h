//
//  MusicClassVC.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^BackBlock)(NSString *type ,NSString *loadPath,NSString *songID);

@interface MusicClassVC : UIViewController

@property(nonatomic,strong)NSString *navi_title;
@property(nonatomic,strong)NSString *class_id;

@property(nonatomic,copy)BackBlock backEvent;

@property(nonatomic,strong)NSString *fromWhere;


@end
