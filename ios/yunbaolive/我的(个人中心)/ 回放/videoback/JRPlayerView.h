
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class JRControlView;
@class JRFullControlView;
@interface JRPlayerView : UIView

@property (nonatomic, strong) AVPlayer			*player;
@property (nonatomic, strong) AVAsset			*asset;
@property (nonatomic, strong) AVPlayerItem		*playerItem;
@property (nonatomic, strong) NSString			*urlString;
@property (nonatomic, strong) NSString			*title;

@property (nonatomic, strong) NSString			*imageUrl;
@property (nonatomic, strong) NSURL				*assetUrl;
@property (nonatomic, strong) JRControlView		*smallControlView;	// 小屏控制 View
@property (nonatomic, strong) JRFullControlView	*fullControlView;

- (instancetype)initWithFrame:(CGRect)frame
						image:(NSString *)imageUrl
						asset:(NSURL *)assetUrl;

- (instancetype)initWithFrame:(CGRect)frame
						asset:(NSURL *)assetUrl;

-(instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithURL:(NSURL *)assetURL;

- (void)prepareToPlay;

- (void)play;

- (void)pause;

// -- 定时器
- (void)addTimer;

- (void)removeTimer;

@end
