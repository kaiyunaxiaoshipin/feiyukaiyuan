//
//  YBBottomView.h
//  TCLVBIMDemo
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBBottpmViewDelegate <NSObject>

-(void)perform:(NSString *)text;

@end

@interface YBBottomView : UIImageView
{
    UILabel *line1;
    UILabel *line2;
}
@property(nonatomic,assign)id<YBBottpmViewDelegate>BottpmViewDelegate;

//传进来的btn数组
@property (nonatomic, strong) NSArray *btnArr;
//num数组
@property (nonatomic, strong) NSArray *numArr;

//直播btn
@property (nonatomic, strong) UIButton *liveBtn;
//直播num
@property (nonatomic, strong) UILabel *liveNum;
//关注btn
@property (nonatomic, strong) UIButton *forceBtn;
//关注num
@property (nonatomic, strong) UILabel *forceNum;
//粉丝btn
@property (nonatomic, strong) UIButton *fanBtn;
//粉丝num
@property (nonatomic, strong) UILabel *fanNum;

-(void)setAgain:(NSArray *)array;

@end
