//
//  videoMoreView.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^xinxinblock)(id array);


@interface videoMoreView : UIView

@property(nonatomic,copy)xinxinblock cancleblock;

@property(nonatomic,copy)xinxinblock deleteblock;

@property(nonatomic,copy)xinxinblock shareblock;

@property(nonatomic,copy)xinxinblock jubaoBlock;


@property(nonatomic,copy)NSString *fromWhere;

-(instancetype)initWithFrame:(CGRect)frame andHostDic:(NSDictionary *)dic cancleblock:(xinxinblock)block delete:(xinxinblock)deleteblock share:(xinxinblock)share;


@end
