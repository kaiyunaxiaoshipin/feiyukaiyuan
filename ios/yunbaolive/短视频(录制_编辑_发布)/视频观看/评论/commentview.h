//
//  commentview.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^commectblock)(id type);

@interface commentview : UIView

@property(nonatomic,copy)commectblock hide;

@property(nonatomic,copy)commectblock talkCount;

@property(nonatomic,copy)commectblock pushDetail;

@property(nonatomic,copy)commectblock youkedenglu;
@property (nonatomic,strong) NSString *fromWhere;
-(instancetype)initWithFrame:(CGRect)frame hide:(commectblock)hide andvideoid:(NSString *)videoid andhostid:(NSString *)hostids count:(int)allcomments talkCount:(commectblock)talk detail:(commectblock)detail youke:(commectblock)youkedenglu andFrom:(NSString *)from;

//-(void)reloaddata;
-(void)getNewCount:(int)count;



@end
