//
//  coastselectview.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^axinblock)(NSString *type);


@interface coastselectview : UIView

@property(nonatomic,copy)axinblock sureblock;
@property(nonatomic,copy)axinblock cancleblock;
-(instancetype)initWithFrame:(CGRect)frame andsureblock:(axinblock)sureblock andcancleblock:(axinblock)cancleblock;
@end
