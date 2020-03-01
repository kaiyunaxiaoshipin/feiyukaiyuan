//
//  YBNavi.h
//  WaWaJiClient
//
//  Created by Rookie on 2017/11/19.
//  Copyright © 2017年 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^btnBlock)(id btnBack);

@interface YBNavi : UIView

//注意！！！ 需要动态改变标题时可启用
@property (nonatomic,strong) UILabel *midTitleL;     //动态改变可外部修改
@property(nonatomic,assign)BOOL dynamicChangeNavBgc; //动态改变导航栏背景色  （从无到有，如果是从有到无，此值不用设置或者设置为NO）
@property(nonatomic,strong)UIImageView *naviBGIV;    //动态改变可外部修改

//注意！！！没有左右返回键一定设置 hidden = YES
@property (nonatomic,assign) BOOL leftHidden;
@property (nonatomic,assign) BOOL rightHidden;

@property(nonatomic,assign)BOOL haveTitleR;     //右边标题
@property(nonatomic,assign)BOOL haveTitleL;     //左边标题
@property(nonatomic,strong)UIButton *leftBtn;   //左边按钮
@property(nonatomic,assign)BOOL haveImgR;       //右边图片
@property(nonatomic,assign)BOOL haveImgL;       //左边图片   默认都是返回图片



/** 中间标题 */
-(void)ybNaviLeft:(btnBlock)leftBtn andRightName:(NSString *)imgN andRight:(btnBlock)rightBtn andMidTitle:(NSString *)midTitle;

/** 中间图片 */
-(void)ybNaviLeft:(btnBlock)leftBtn andRightName:(NSString *)imgN andRight:(btnBlock)rightBtn andMidImg:(NSString *)imgName;

@end
