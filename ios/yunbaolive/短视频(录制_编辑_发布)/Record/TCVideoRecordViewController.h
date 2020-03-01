#import <UIKit/UIKit.h>

/**
 *  短视频录制VC
 */
@interface TCVideoRecordViewController : UIViewController

-(void)onBtnCloseClicked;

@property(nonatomic,strong)NSString *musicPath;
@property(nonatomic,strong)NSString *musicID;    //选取音乐的ID
@property(nonatomic,assign)BOOL haveBGM;         //yes-开拍时候选择了音乐  no-未选择音乐直接开拍



@end
