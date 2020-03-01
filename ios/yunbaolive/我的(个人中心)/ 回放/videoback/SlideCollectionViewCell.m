//
//  SlideCollectionViewCell.m
//  JR-Player
//
//  Created by 王潇 on 16/3/10.
//  Copyright © 2016年 王潇. All rights reserved.
//

#import "SlideCollectionViewCell.h"

@interface SlideCollectionViewCell ()
@property (nonatomic, strong) UIActivityIndicatorView	*activity;
@property (nonatomic, strong) UIImageView				*imageView;
@property (nonatomic, strong) UILabel					*timeLabel;
@end

@implementation SlideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		self.activity = ({
			UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] init];
			[act startAnimating];
			[self addSubview:act];
			act;
		});
		self.imageView = ({
			UIImageView *imgView = [[UIImageView alloc] init];
			imgView.hidden		 = YES;
			imgView.userInteractionEnabled = YES;
			[self addSubview:imgView];
			imgView;
		});
		self.timeLabel = ({
			UILabel *label			= [[UILabel alloc] init];
			label.font				= [UIFont systemFontOfSize:10];
			label.hidden			= YES;
			label.backgroundColor	= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
			label.textAlignment		= NSTextAlignmentRight;
			[label setTextColor:[UIColor whiteColor]];
			[self addSubview:label];
			label;
		});
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.activity.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
	self.imageView.frame = self.bounds;
	CGFloat labelY		 = self.bounds.size.height - 16;
	self.timeLabel.frame = CGRectMake(0, labelY, self.bounds.size.width, 16);
}

- (void)setModel:(SlideModel *)model {
	_model = model;
	self.activity.hidden  = YES;
	self.imageView.hidden = NO;
	self.timeLabel.hidden = NO;
	
	self.imageView.image = model.image;
//	self.timeLabel.text  = [NSString stringWithFormat:@"%zd", model.time.value / model.time.timescale];
}

- (void)setTimeString:(NSString *)timeString {
	_timeString = timeString;
	self.timeLabel.text = timeString;
}

@end

@implementation SlideModel

- (instancetype)initWithImage:(UIImage *)image time:(CMTime)time {
	
	if (self = [super init]) {
		_image = image;
		_time  = time;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ - %lld", self.image, self.time.value / self.time.timescale];
}

@end

