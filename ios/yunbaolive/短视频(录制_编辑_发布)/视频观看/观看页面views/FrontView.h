//
//  FrontView.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/9.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKLampView.h"

typedef void (^FrontBlock)(NSString *type);

@interface FrontView : UIView


/** 头像 点赞 评论 分享集合 */
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong) UIButton *iconBtn;
@property(nonatomic,strong) UIButton *followBtn;                    //关注
@property(nonatomic,strong) UIButton *likebtn;                      //点赞

@property(nonatomic,strong) UIButton *commentBtn;
@property(nonatomic,strong) UIButton *enjoyBtn;
@property(nonatomic,strong)UIImageView *discIV;                     //唱片背景
@property(nonatomic,strong)UIImageView *musicIV;                    //歌曲背景图
@property(nonatomic,strong)UIImageView *symbolAIV;                  //音符A
@property(nonatomic,strong)UIImageView *symbolBIV;                  //音符B


/** 名字 标题 (音乐)集合 */
@property(nonatomic,strong)UIView *botView;
@property(nonatomic,strong)RKLampView *musicL;                    //音乐
@property(nonatomic,strong)UILabel *titleL;                         //视频标题
@property(nonatomic,strong)UILabel *nameL;


- (instancetype)initWithFrame:(CGRect)frame callBackEvent:(FrontBlock)event;

-(void)updateData:(NSDictionary*)dic;
-(void)setMusicName:(NSString *)str;

@end
