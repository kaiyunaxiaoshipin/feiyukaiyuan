//
//  WPFRotateView.h
//  01-幸运转盘第二遍
//
//  Created by 王鹏飞 on 16/1/13.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//
#import <UIKit/UIKit.h>
@class WPFRotateView;
// 制定协议
@protocol WPFRotateViewDelegate <NSObject>
@optional;
- (void)didFinishSelNum:(WPFRotateView *)rotateView;
-(void)pushCoinV;
//开始倒计时
-(void)startRotationGameSocketToken:(NSString *)token andGameID:(NSString *)ID andTime:(NSString *)time;

-(void)skateRotaton:(NSString *)type andMoney:(NSString *)money;//用户投注


-(void)stopRotationgameBySelf;


@end
@interface WPFRotateView : UIView
- (IBAction)doRotation:(id)sender;
-(void)isHost:(BOOL)isHost andHostDic:(NSString *)hoststream;
-(void)movieplayStartCut:(NSString *)time andGameid:(NSString *)gameid;//开始倒计时(moveiplay)
@property(nonatomic,strong)NSString *stream;
@property (weak, nonatomic) IBOutlet UIButton *actionbtn;
@property (weak, nonatomic) IBOutlet UIImageView *deng;
@property (weak, nonatomic) IBOutlet UIImageView *bgBtn;
/** 类方法，快速创建转盘 */
+ (instancetype)rotateView;
-(void)hostgetstart;
-(void)removeall;
/** 对象方法，让转盘开始旋转 */
- (void)startRotating;
-(void)getRotationCoinType:(NSString *)type andMoney:(NSString *)money;//更新押注
-(void)stopRotatipnGameInt;
-(void)getRotationResult:(NSArray *)array;
/** 绑定代理对象 */
@property (nonatomic, weak) id<WPFRotateViewDelegate> delegate;

/** 转盘类别 */
@property (nonatomic, copy) NSString *function;
-(void)continueGame:(NSString *)time andgameId:(NSString *)gameid andMoney:(NSArray *)moneys andmycoin:(NSArray *)moneyss;
-(void)addtableview;
-(void)reloadcoins;
-(void)stoplasttimer;
-(void)setlayoutview;

@end
