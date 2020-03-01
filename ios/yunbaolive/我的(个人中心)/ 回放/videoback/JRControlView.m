
#import "JRControlView.h"
#import "JRPlayerView.h"
#import "SlideCollectionViewCell.h"
#import "MSWeakTimer.h"
#define MARGIN		5
#define BAR_H		30
#define LABEL_H		20
#define LABEL_W		45
#define CHOOSE		20
#define HEAD_H		40
#define BTN_H		30
#define COLL_H		56
#define COLL_Y		-COLL_H
#define SLID_C		20
#define CONT_BTN	5
@interface JRControlView () <UICollectionViewDelegate, UICollectionViewDataSource>
// --- View
@property (nonatomic, strong) UIButton			*playBtn;
@property (nonatomic, strong) UILabel			*currentTime;
@property (nonatomic, strong) UILabel			*totleTime;
@property (nonatomic, strong) UIButton			*chooseBtn;
@property (nonatomic, strong) UIProgressView	*progressView;
@property (nonatomic, strong) UISlider			*sliderView;
@property (nonatomic, strong) MSWeakTimer		*timer;
@property (nonatomic, assign) BOOL				isSliding;
@property (nonatomic, strong) UIView			*headerView;
@property (nonatomic, strong) UIView			*footerView;
@property (nonatomic, strong) UIButton			*closeBtn;			//
@property (nonatomic, strong) UILabel			*titleLabel;		//
@property (nonatomic, strong) UIButton			*shearBtn;			//
@property (nonatomic, strong) UIButton			*downBtn;			//
@property (nonatomic, strong) UIButton			*slidBtn;			//
//		|c|t|s|d|s|
@property (nonatomic, strong) UICollectionView		*collectionView;	// 选择
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong,) NSMutableArray		*imagesArray;
@property (nonatomic, strong) UICollectionViewFlowLayout	*layout;
@property (nonatomic, strong) NSMutableArray	*btnArray;
@property (nonatomic, strong) NSMutableArray	*imgArray;
@property (nonatomic, strong) NSMutableArray	*timArray;
// 通知
@property (strong, nonatomic) id				itemEndObserver;
@property (strong, nonatomic) id				itemEndObserver2;
@property (strong, nonatomic) id				itemEndObserver4;
@end
@implementation JRControlView
- (instancetype)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
        
        
		//
		self.headerView = ({
			UIView *header = [[UIView alloc] init];
			header.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
			[self addSubview:header];
			header;
		});
		self.footerView = ({
			UIView *footer = [[UIView alloc] init];
			footer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
			[self addSubview:footer];
			footer;
		});
		
		self.playBtn = ({
			UIButton *playBtn = [[UIButton alloc] init];
			[playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
			[playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
			[playBtn addTarget:self action:@selector(playControl) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:playBtn];
			playBtn;
		});
		self.currentTime = ({
			UILabel *label	= [[UILabel alloc] init];
			label.font		= [UIFont systemFontOfSize:10];
			label.textAlignment = NSTextAlignmentCenter;
			[label setTextColor:[UIColor whiteColor]];
			[self addSubview:label];
			label;
		});
		self.sliderView = ({
			UISlider *slider = [[UISlider alloc] init];
			slider.minimumValue = 0.0;
			slider.maximumValue = 1.0;
			[slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
			[slider addTarget:self action:@selector(slideAction) forControlEvents:UIControlEventValueChanged];
			[slider addTarget:self action:@selector(slideOver) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel];
            [slider setTintColor:normalColors];
			[self addSubview:slider];
			slider;
		});
		self.totleTime = ({
			UILabel *label	= [[UILabel alloc] init];
			label.font		= [UIFont systemFontOfSize:10];
			label.textAlignment = NSTextAlignmentCenter;
			[label setTextColor:[UIColor whiteColor]];
			[self addSubview:label];
			label;
		});
		self.chooseBtn = ({
			UIButton *btn		= [[UIButton alloc] init];
			[btn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:btn];
			btn;
		});
		
		self.closeBtn = ({
			UIButton *closeBtn = [[UIButton alloc] init];
			[closeBtn setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
			[closeBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
			[self.headerView addSubview:closeBtn];
			closeBtn;
		});
		self.titleLabel = ({
			UILabel *title = [[UILabel alloc] init];
			title.font = [UIFont systemFontOfSize:14];
			[title setTextColor:[UIColor whiteColor]];
			[self.headerView addSubview:title];
			title;
		});
		self.shearBtn = ({
			UIButton *share = [[UIButton alloc] init];
			[share setImage:[UIImage imageNamed:@"share_normal"] forState:UIControlStateNormal];
			[share setImage:[UIImage imageNamed:@"share_selected"] forState:UIControlStateHighlighted];
			share.contentMode = UIViewContentModeCenter;
			[self.headerView addSubview:share];
			share;
		});
		self.downBtn = ({
			UIButton *down = [[UIButton alloc] init];
			[down setImage:[UIImage imageNamed:@"down_normal"] forState:UIControlStateNormal];
			[down setImage:[UIImage imageNamed:@"down_selected"] forState:UIControlStateSelected];
			[self.headerView addSubview:down];
			down;
		});
        
        
		self.slidBtn = ({
			UIButton *slidBtn = [[UIButton alloc] init];
			//			[slidBtn setImage:[UIImage imageNamed:@"tab_poster_nav_n"] forState:UIControlStateNormal];
			[slidBtn addTarget:self action:@selector(openSlidView) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:slidBtn];
			slidBtn;
		});

        
        self.chooseBtn.hidden = YES;
        self.playBtn.hidden = YES;
        self.headerView.hidden = YES;
        
		[self addTimer];
		[self addNSNotificationCenter];
	}
	return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    return view;
}
#pragma mark - Controller Methond
- (void)layoutSubviews {
	[super layoutSubviews];
	
	// 0. |c|s|t|y|
	CGRect frame = self.bounds;
	CGFloat barY = frame.size.height - BAR_H;
	// 1. playBtn
	//	self.playBtn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
	self.playBtn.frame = CGRectMake(MARGIN, barY, CHOOSE, CHOOSE);
	// 2. currentTime
	CGFloat curX = CGRectGetMaxX(self.playBtn.frame) + MARGIN;
	self.currentTime.frame = CGRectMake(curX, barY + MARGIN, LABEL_W, LABEL_H);
	// 3. sliderView
	curX = CGRectGetMaxX(self.currentTime.frame) + MARGIN;
	CGFloat slidW = self.bounds.size.width - MARGIN * 6 - 30 - LABEL_W * 2 - CHOOSE;
	self.sliderView.frame = CGRectMake(curX, barY + MARGIN, slidW, LABEL_H);
	// 4. totleTime
	curX = CGRectGetMaxX(self.sliderView.frame) + MARGIN;
	self.totleTime.frame = CGRectMake(curX, barY + MARGIN, LABEL_W, LABEL_H);
	// 5. chooseBtn
	curX = CGRectGetMaxX(self.totleTime.frame) + MARGIN;
	self.chooseBtn.frame = CGRectMake(curX, barY, CHOOSE, CHOOSE);
	
	if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait && self.bounds.size.width > 500) {
		self.headerView.frame = CGRectMake(0, 0, self.bounds.size.width, HEAD_H);
		self.footerView.frame = CGRectMake(0, self.bounds.size.height - HEAD_H, self.bounds.size.width, HEAD_H);
		self.closeBtn.frame	  = CGRectMake(MARGIN, MARGIN, HEAD_H, BTN_H);
		CGFloat titleW		  = self.bounds.size.width - 6 * MARGIN - 4 * HEAD_H;
		self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.closeBtn.frame) + MARGIN, MARGIN, titleW, BTN_H);
		self.shearBtn.frame	  = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + MARGIN, 0, HEAD_H, HEAD_H);
		self.downBtn.frame	  = CGRectMake(CGRectGetMaxX(self.shearBtn.frame) + MARGIN, 0, HEAD_H, HEAD_H);
		self.slidBtn.frame	  = CGRectMake(CGRectGetMaxX(self.downBtn.frame) + MARGIN, 0, HEAD_H, HEAD_H);
		
		self.headerView.hidden = NO;
		self.collectionView.hidden = NO;
		[self showAllBtn];
	} else {
		self.headerView.frame  = CGRectMake(0, 0, 0, 0);
		self.footerView.frame  = CGRectMake(0, self.bounds.size.height - BAR_H, self.bounds.size.width, BAR_H);
		self.headerView.hidden = YES;
		self.collectionView.hidden = YES;
		[self hiddenAllBtn];
	}
}
- (void)dealloc {
	NSLog(@"===== 释放");
	[self removeTimer];
	if (self.itemEndObserver) {                                             // 5
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self.itemEndObserver
					  name:AVPlayerItemDidPlayToEndTimeNotification
					object:self.player.player.currentItem];
		self.itemEndObserver = nil;
		
	}
	if (self.itemEndObserver2) {                                             // 5
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self.itemEndObserver2
					  name:AVPlayerItemPlaybackStalledNotification
					object:self.player.player.currentItem];
		self.itemEndObserver2 = nil;
		
	}
	
	if (self.itemEndObserver4) {                                             // 5
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self.itemEndObserver4
					  name:AVPlayerItemTimeJumpedNotification
					object:self.player.player.currentItem];
		self.itemEndObserver4 = nil;
		
	}
}
#pragma mark - Property Methond
- (void)setPlayer:(JRPlayerView *)player {
	_player = player;
	
	if (player.player.rate != 0.0) {
		self.playBtn.selected = YES;
	}
	
	CMTime time			= self.player.player.currentTime;
	CMTime time2		= self.player.playerItem.duration;
	CGFloat currentTime = time.value / (CGFloat)time.timescale;
	CGFloat totleTime	= time2.value / (CGFloat)time2.timescale;
	NSString *current	= [self calcSeconds:currentTime];
	NSString *totle		= [self calcSeconds:totleTime];
	self.currentTime.text = current;
	self.totleTime.text   = totle;
}

- (void)openSlidView {
	
	if (self.isShow == YES) {
		[self.player addTimer];
	}
	[self openSlidView:nil];
}

- (void)openSlidView:(void(^)())action {
	
	[self createSlideView];
	NSLog(@"=========================== CLOSE");
	if (self.isShow == NO) {
		[UIView animateWithDuration:0.5 animations:^{
			self.collectionView.frame = CGRectMake(0, HEAD_H, self.bounds.size.width, COLL_H);
		} completion:^(BOOL finished) {
			self.isShow = YES;
			[self.player removeTimer];
		}];
	} else {
		[UIView animateWithDuration:0.5 animations:^{
			self.collectionView.frame = CGRectMake(0, COLL_Y, self.bounds.size.width, COLL_H);
		} completion:^(BOOL finished) {
			self.isShow = NO;
			if (action) {
				action();
			}
		}];
	}
}

- (void)createSlideView {
	if (self.collectionView) return;
	
	//	self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.player.asset];
	self.imageGenerator.maximumSize = CGSizeMake(200.0f, 0.0f);             // 2
	
	CMTime duration = self.player.asset.duration;
	NSMutableArray *times = [NSMutableArray array];                         // 3
	CMTimeValue increment = duration.value / SLID_C;
	CMTimeValue currentValue = 2.0 * duration.timescale;
	while (currentValue <= duration.value) {
		CMTime time = CMTimeMake(currentValue, duration.timescale);
		[times addObject:[NSValue valueWithCMTime:time]];
		currentValue += increment;
	}
	
	self.imagesArray = [NSMutableArray array];
	__block NSUInteger imageCount = times.count;                            // 4
	__block NSMutableArray *images = [NSMutableArray array];
	
	AVAssetImageGeneratorCompletionHandler handler;
	
	handler = ^(CMTime requestedTime,
				CGImageRef imageRef,
				CMTime actualTime,
				AVAssetImageGeneratorResult result,
				NSError *error) {
		
		if (result == AVAssetImageGeneratorSucceeded) {                     // 6
			UIImage *image = [UIImage imageWithCGImage:imageRef];
			
			SlideModel *model = [[SlideModel alloc] initWithImage:image time:actualTime];
			[images addObject:model];
			[self.imagesArray addObject:model];
		} else {
			NSLog(@"Error: %@", [error localizedDescription]);
		}
		
		// If the decremented image count is at 0, we're all done.
		if (--imageCount == 0) {                                            // 7
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.collectionView reloadData];
			});
		}
	};
	
	[self.imageGenerator generateCGImagesAsynchronouslyForTimes:times       // 8
											  completionHandler:handler];
	
	self.collectionView = ({
		UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, COLL_Y, self.bounds.size.width, COLL_H)
															  collectionViewLayout:self.layout];
		
		collectionView.dataSource = self;
		collectionView.delegate   = self;
		collectionView.userInteractionEnabled	   = YES;
		collectionView.showsHorizontalScrollIndicator = NO;
		[collectionView registerClass:[SlideCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
		collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		[self insertSubview:collectionView belowSubview:self.headerView];
		collectionView;
	});
}

- (void)setTitle:(NSString *)title {
	_title = title;
	
	if (self.titleLabel) {
		self.titleLabel.text = title;
	}
}

#pragma mark - PAN

- (void)addPanGesture {
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
																		  action:@selector(panAction:)];
	
	[self addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
	
	NSLog(@"==================== %@", [gesture class]);
	
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	if (self.imagesArray.count == SLID_C) {
		return self.imagesArray.count;
	}
	return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	SlideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	if (self.imagesArray.count == SLID_C) {
		cell.model  = self.imagesArray[indexPath.row];
		CMTime time = cell.model.time;
		cell.timeString  = [self calcSeconds:time.value / time.timescale];
	}
    
	return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.imagesArray.count == SLID_C) {
		CMTime time = [self.imagesArray[indexPath.row] time];
		[self.player.player seekToTime:time];
		[self setSlideValue:time];
	}
}
#pragma mark - NSNotificationCenter
- (void)addNSNotificationCenter {
	[self addItemEndObserverForPlayerItem];
	[self addItemEndObserverForPlayerItem2];
	[self addItemEndObserverForPlayerItem4];
}
// 播放完成
- (void)addItemEndObserverForPlayerItem {
	
	NSString *name = AVPlayerItemDidPlayToEndTimeNotification;
	NSOperationQueue *queue = [NSOperationQueue mainQueue];
	
	__weak JRControlView *weakSelf = self;                             // 1
	void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
		[weakSelf.player.player seekToTime:kCMTimeZero                             // 2
						 completionHandler:^(BOOL finished) {
							 [weakSelf.player pause];
							 weakSelf.playBtn.selected = NO;
						 }];
	};
	
	self.itemEndObserver =                                                  // 4
	[[NSNotificationCenter defaultCenter] addObserverForName:name
													  object:self.player.playerItem
													   queue:queue
												  usingBlock:callback];
}
// 播放失败
- (void)addItemEndObserverForPlayerItem2 {
	
    // 播放出现问题
	NSString *name = AVPlayerItemPlaybackStalledNotification;
	NSOperationQueue *queue = [NSOperationQueue mainQueue];
	
	__weak JRControlView *weakSelf = self;
	void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
		NSLog(@"=========================AAAAAAAAAAAAAAAAA");
		weakSelf.playBtn.selected = NO;
        
        
        
	};
	
	self.itemEndObserver2 =                                                  // 4
	[[NSNotificationCenter defaultCenter] addObserverForName:name
													  object:self.player.playerItem
													   queue:queue
												  usingBlock:callback];
}
// 跳转
- (void)addItemEndObserverForPlayerItem4 {
	
	NSString *name = AVPlayerItemTimeJumpedNotification;
	NSOperationQueue *queue = [NSOperationQueue mainQueue];
	
	void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
        
        
        
		NSLog(@"===========|||AVPlayerItemTimeJumpedNotification  %@", notification.userInfo);
	};
	
	self.itemEndObserver4 =                                                  // 4
	[[NSNotificationCenter defaultCenter] addObserverForName:name
													  object:self.player.playerItem
													   queue:queue
												  usingBlock:callback];
}

#pragma mark - Control Methond
- (void)addTimer {
	
	if (self.timer) return;
	
	self.timer = ({
		MSWeakTimer *timer = [MSWeakTimer scheduledTimerWithTimeInterval:1.0f
																  target:self
																selector:@selector(updateSlide)
																userInfo:nil
																 repeats:YES
														   dispatchQueue:dispatch_get_main_queue()];
		timer;
	});
}


- (void)removeTimer {
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (void)playControl {
	
	if (self.player.player.rate == 0.0) {	// bug
		[self.player play];
		[self addTimer];
		self.playBtn.selected = YES;
	} else {
		[self.player pause];
		[self removeTimer];
		self.playBtn.selected = NO;
	}
}

- (void)slideAction {
	self.isSliding = YES;
	[self.player removeTimer];
}

- (void)slideOver {
	
	if (!self.player.player || self.player.player.status == AVPlayerStatusUnknown) return;
	
	CMTime time2		= self.player.playerItem.duration;
	CGFloat totleTime	= time2.value / (CGFloat)time2.timescale;
	CGFloat second		= totleTime * self.sliderView.value;
	CMTime time = CMTimeMake((double)second, (int)1);
	[self.player.player seekToTime:time completionHandler:^(BOOL finished) {
		self.isSliding = NO;
	}];
	[self.player addTimer];
}

#pragma mark - View Methond
- (void)addControlBtn {
	
	if (!self.sliderView || self.btnArray.count > 0 || !self.player) return;
	
	self.btnArray = [NSMutableArray array];
	self.imgArray = [NSMutableArray array];
	
	for (int i = 1; i <= CONT_BTN; i++) {
		UIButton *btn = [[UIButton alloc] init];
		btn.tag = i;
		btn.userInteractionEnabled = NO;
		[self.btnArray addObject:btn];
		//		[self.sliderView insertSubview:btn atIndex:0];		// 1.
		[self addSubview:btn];								// 2.
		[btn setImage:[UIImage imageNamed:@"slider_tip"] forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
		
		UIButton *img	= [[UIButton alloc] init];
		img.hidden		= YES;
		img.tag			= i;
		[self addSubview:img];
		//		[img setImage:[UIImage imageWithCGImage:image] forState:UIControlStateNormal];
		[img addTarget:self action:@selector(imgDidselected:) forControlEvents:UIControlEventTouchUpInside];
		img.backgroundColor = [UIColor blackColor];
		[self.imgArray addObject:img];
	}
	
	[self setimgArrayImage];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																		  action:@selector(selectTap:)];
	[self.sliderView addGestureRecognizer:tap];
}

- (void)setimgArrayImage {
	
	self.timArray = [NSMutableArray array];
	CMTime duration = self.player.asset.duration;
	CGFloat time = duration.value / duration.timescale;
	CGFloat tip = time / 6;
	for (int i = 0; i < 5; i++) {
		int64_t t = tip * (i + 1);
		CMTime time = CMTimeMake((int64_t)t, 1);
		[self.timArray addObject:[NSValue valueWithCMTime:time]];
	}
	__block NSInteger count = 0;
	AVAssetImageGeneratorCompletionHandler handler;
	handler = ^(CMTime requestedTime,
				CGImageRef imageRef,
				CMTime actualTime,
				AVAssetImageGeneratorResult result,
				NSError *error) {
		
		if (result == AVAssetImageGeneratorSucceeded) {                     // 6
			UIImage *image = [UIImage imageWithCGImage:imageRef];
			dispatch_async(dispatch_get_main_queue(), ^{
				if (count < self.imgArray.count) {
					UIButton *btn = self.imgArray[count];
					[btn setImage:image forState:UIControlStateNormal];
					count ++;
				}
			});
			
		} else {
			NSLog(@"Error: %@", [error localizedDescription]);
		}
	};
	
	[self.imageGenerator generateCGImagesAsynchronouslyForTimes:self.timArray       // 8
											  completionHandler:handler];
}
- (void)imgDidselected:(UIButton *)sender {
	if (sender.tag <= self.timArray.count) {
		CMTime time = [self.timArray[sender.tag-1] CMTimeValue];
		[self.player.player seekToTime:time];
		[self.player.player seekToTime:time completionHandler:^(BOOL finished) {
			[self setSlideValue:time];
		}];
	}
}
- (void)selectTap:(UITapGestureRecognizer *)gesture {
	
	if (self.btnArray.count == 0) return;
	
	//	CGPoint point = [gesture locationInView:self.sliderView];					// 1.
	CGPoint point = [gesture locationInView:self];					// 2.
	for (int i = 0; i < self.btnArray.count; i++) {
		UIButton *btn = self.btnArray[i];
		if (CGRectContainsPoint(btn.frame, point)) {
			[self imageSelected:i];
			break;
		}
	}
}
// 废弃
- (void)btnSelected:(UIButton *)sender {
	
}
- (void)imageSelected:(NSInteger)index {
	
	for (int i = 0; i < self.imgArray.count; i++) {
		UIButton *btn = self.imgArray[i];
		if (index == i) {
			btn.hidden = !btn.hidden;
		} else {
			btn.hidden = YES;
		}
	}
}
- (void)closeAllImgArray {
	for (UIButton *btn in self.imgArray) {
		btn.hidden = YES;
	}
}
- (void)hiddenAllBtn {
	if (self.btnArray.count == 0) return;
	for (UIButton *btn in self.btnArray) {
		btn.hidden = YES;
	}
}
- (void)hiddenAllImageBtn {
	if (self.imgArray.count == 0) return;
	for (UIButton *btn in self.imgArray) {
		btn.hidden = YES;
	}
}
- (void)showAllBtn {
	if (self.btnArray.count == 0) return;
	//	CGFloat btnY = 0;																				// 1.
	CGFloat btnY = CGRectGetMaxY(self.sliderView.frame) - self.sliderView.frame.size.height;		// 2.
	CGFloat btnH = 20;
	CGFloat btnW = 20;
	//CGFloat imgW = 40;
	CGFloat x = self.sliderView.frame.size.width / (self.btnArray.count + 1) - 4;
	for (int i = 0; i < self.btnArray.count; i++) {
		UIButton *btn = self.btnArray[i];
		btn.hidden = NO;
		//		CGFloat btnX = (i+1) * x;												// 1.
		CGFloat btnX = (i+1) * x + self.sliderView.frame.origin.x ;			// 2.
		btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
		
		UIButton *img = self.imgArray[i];
		img.frame = CGRectMake(0, 0, 120, 67);
		img.center = CGPointMake(btn.center.x, btn.center.y - 50);
	}
}
// 设置 Slider Value
- (void)setSlideValue:(CMTime)time {
	CMTime time2		= self.player.playerItem.duration;
	CGFloat currentTime = time.value / (CGFloat)time.timescale;
	CGFloat totleTime	= time2.value / (CGFloat)time2.timescale;
	CGFloat value = currentTime / totleTime;
	if (value >=0 && value <= 1) {
		self.sliderView.value = value;
	}
}
- (void)updateSlide {
	
	// slider
	CMTime time			= self.player.player.currentTime;
	CMTime time2		= self.player.playerItem.duration;
	CGFloat currentTime = time.value / (CGFloat)time.timescale;
	CGFloat totleTime	= time2.value / (CGFloat)time2.timescale;
	if (self.isSliding == NO) {
		self.sliderView.value =  currentTime / totleTime;
	}
	
	// time
	NSString *current	= [self calcSeconds:currentTime];
	NSString *totle		= [self calcSeconds:totleTime];
	self.currentTime.text = current;
	self.totleTime.text   = totle;
}
- (NSString *)calcSeconds:(CGFloat)seconds {
	
	NSInteger hour = seconds / 3600;
	NSInteger time = (NSInteger)seconds % 3600;
	NSInteger min  = (NSInteger)time / 60;
	NSInteger sec  = time % 60;
	return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)min, (long)sec];
}
- (void)fullScreen {
	if ([self.delegate respondsToSelector:@selector(fullScreenDidSelected)]) {
		[self.delegate fullScreenDidSelected];
	}
}
#pragma mark - Layz Loading
- (UICollectionViewFlowLayout *)layout {
	if (_layout) {
		return _layout;
	}
	
	_layout = [[UICollectionViewFlowLayout alloc] init];
	_layout.minimumLineSpacing		= 0;
	_layout.minimumInteritemSpacing = 0;
	_layout.itemSize				= CGSizeMake(100, 56);
	_layout.scrollDirection			= UICollectionViewScrollDirectionHorizontal;
	
	return _layout;
}
- (AVAssetImageGenerator *)imageGenerator {
	if (_imageGenerator) {
		return _imageGenerator;
	}
	
	_imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.player.asset];
	
	return _imageGenerator;
}
@end





