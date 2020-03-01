//
//  musicView.h
//  iphoneLive
//
//  Created by zqm on 16/5/4.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^MusicPathBlock)(NSString *event,NSString *musicID);

@interface musicViewVideo : UIViewController

@property(nonatomic,copy)MusicPathBlock pathEvent;
@property(nonatomic,strong)NSString *fromWhere;

@end
