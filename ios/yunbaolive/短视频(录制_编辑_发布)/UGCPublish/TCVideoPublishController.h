//#import "TCMsgModel.h"
//#import <TXLiteAVSDK_UGC/TXVideoEditerTypeDef.h>
#import <TXLiteAVSDK_Professional/TXVideoEditerTypeDef.h>

//#import "TXVideoEditerTypeDef.h"
//#import "TXUGCPublishListener.h"
//#import <TXLiteAVSDK_UGC/TXUGCPublishListener.h>
#define kRecordType_Camera 0
#define kRecordType_Play 1

@interface TCVideoPublishController : UIViewController<UITextViewDelegate>

@property(nonatomic,strong)NSString *musicID;    //选取音乐的ID

- (instancetype)initWithPath:(NSString *)videoPath videoMsg:(TXVideoInfo *) videoMsg;

@end
