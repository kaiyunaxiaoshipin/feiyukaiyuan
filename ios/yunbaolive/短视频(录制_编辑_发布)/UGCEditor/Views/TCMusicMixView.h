//
//  MusicMixView.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/12.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMusicCollectionCell.h"


@protocol TCMusicMixViewDelegate <NSObject>

- (void)onSetVideoVolume:(CGFloat)videoVolume musicVolume:(CGFloat)musicVolume;
/** 如果filePath == delate说明是删除掉了这里是为了和filePath == nil做区别 *///--->废弃删除改为  delBGM
- (void)onSetBGMWithFilePath:(NSString*)filePath startTime:(CGFloat)startTime endTime:(CGFloat)endTime;
-(void)delBGM;

@end

@interface TCMusicMixView : UIView

@property (nonatomic, weak) id<TCMusicMixViewDelegate> delegate;

@property(nonatomic,strong)UIView*  editView;               //包含：音乐名称、音频剪辑slider等外部需要控制hidden属性

- (id)initWithFrame:(CGRect)frame haveBgm:(BOOL)haveBGM;    //yes-开拍时候选择了音乐  no-未选择音乐直接开拍
- (void)addMusicInfo:(TCMusicInfo*)musicInfo;

@end
