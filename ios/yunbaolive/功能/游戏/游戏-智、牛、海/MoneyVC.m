//
//  MoneyVC.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "MoneyVC.h"

@interface MoneyVC (){
    
}
@end
@implementation MoneyVC

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
      //[self setBackgroundImage:[UIImage imageNamed:@"img_goldflower_betbg"] forState:UIControlStateNormal];
        _allCoinLabel = [[UITextField alloc]initWithFrame:CGRectMake(5,20, self.frame.size.width, 20)];
        _allCoinLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:10];
        _allCoinLabel.textColor = RGB(137, 61, 14);
        _allCoinLabel.textAlignment = NSTextAlignmentLeft;
        _allCoinLabel.enabled = NO;
        [self addSubview:_allCoinLabel];
        _myCoinLabel = [[UITextField alloc]initWithFrame:CGRectMake(5,55, self.frame.size.width, 20)];
        _myCoinLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        _myCoinLabel.textColor = RGB(137, 61, 14);
        _myCoinLabel.textAlignment = NSTextAlignmentLeft;
        _myCoinLabel.enabled = NO;
        UIImageView *imagev1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,10,10)];
        imagev1.image = [UIImage imageNamed:@"dianzan"];
        _allCoinLabel.leftViewMode = UITextFieldViewModeAlways;
        _allCoinLabel.leftView = imagev1;
        UIImageView *imagev2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10,10)];
        imagev2.image = [UIImage imageNamed:@"dianzan"];
        _myCoinLabel.leftViewMode = UITextFieldViewModeAlways;
        _myCoinLabel.leftView = imagev2;
        [self addSubview:_myCoinLabel];
        _allLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
        _myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
        _allLabel.textColor = [UIColor clearColor];
        _myLabel.textColor = [UIColor clearColor];
        [self addSubview:_allLabel];
        [self addSubview:_myLabel];
    }
    return self;
}
@end
