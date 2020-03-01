//
//  MusicCell.h
//  iphoneLive
//
//  Created by YunBao on 2018/6/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;

typedef void (^MusicRecordBlock)(NSString *type);
typedef void (^MusicDownLoadResault)(NSString *rs,NSString *erro);

@interface MusicCell : UITableViewCell

@property(nonatomic,strong)MusicModel *model;

@property(nonatomic,copy)NSString *songID;                          //歌曲ID
@property (nonatomic,copy) NSString *path;                          //音乐下载链接
@property (weak, nonatomic) IBOutlet UIView *topBgV;

@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UILabel *musicNameL;
@property (weak, nonatomic) IBOutlet UILabel *singerL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;              //收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *StateBtn;            //音乐播放状态

@property (weak, nonatomic) IBOutlet UIButton *startRecoedBtn;      //开始录制
@property(nonatomic,copy)MusicRecordBlock recordEvent;              //开始录制回调
@property(nonatomic,copy)MusicDownLoadResault rsEvent;              //音乐下载事件

/** 收藏 */
- (IBAction)clickUseBtn:(UIButton *)sender;
/** 开始录制 */
- (IBAction)clickStartRecordBtn:(UIButton *)sender;

+(MusicCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath;

-(void)musicDownLoad;

@end
