//
//  MsgTopPubCell.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgTopPubModel.h"

@protocol MsgClickDelegate <NSObject>

-(void)iconClickUid:(NSString *)uid;
-(void)coverClickVideoid:(NSString *)videoid;

@end

@interface MsgTopPubCell : UITableViewCell

@property(nonatomic,assign)id<MsgClickDelegate> delegatge;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property(nonatomic,strong)MsgTopPubModel *model;

- (IBAction)clickIconBtn:(UIButton *)sender;
- (IBAction)clickCoverBtn:(UIButton *)sender;
+(MsgTopPubCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath;

@end
