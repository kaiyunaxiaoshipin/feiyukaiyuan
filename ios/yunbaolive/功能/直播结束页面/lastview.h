//
//  lastview.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/31.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^xinblocks)(NSString *nulls);

@interface lastview : UIView

-(instancetype)initWithFrame:(CGRect)frame block:(xinblocks)blocks andavatar:(NSString *)avatar;

@property(nonatomic,copy)xinblocks blocks;


@end
