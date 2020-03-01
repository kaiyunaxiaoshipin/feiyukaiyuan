//
//  TCVideoEditViewController.h
//  TCLVBIMDemo
//
//  Created by xiang zhang on 2017/4/10.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface TCVideoEditViewController : UIViewController

@property (strong,nonatomic) NSString *videoPath;

@property (strong,nonatomic) AVAsset  *videoAsset;

@property(nonatomic,strong)NSString *musicPath;
@property(nonatomic,strong)NSString *musicID;     //选取音乐的ID
@property(nonatomic,assign)BOOL haveBGM;          //yes-开拍时候选择了音乐  no-未选择音乐直接开拍


@end
