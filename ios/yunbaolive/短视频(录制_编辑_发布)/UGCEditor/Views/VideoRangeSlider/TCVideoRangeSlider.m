//
//  TCVideoRangeSlider.m
//  SAVideoRangeSliderExample
//
//  Created by annidyfeng on 2017/4/18.
//  Copyright © 2017年 Andrei Solovjev. All rights reserved.
//

#import "TCVideoRangeSlider.h"
#import "UIView+Additions.h"
#import "UIView+CustomAutoLayout.h"
#import "TCVideoRangeConst.h"

@interface TCVideoRangeSlider()<TCRangeContentDelegate, UIScrollViewDelegate>

@property BOOL disableSeek;

@end

@implementation TCVideoRangeSlider
{
    
    BOOL  _startColor;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.bgScrollView = ({
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [self addSubview:scroll];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.scrollsToTop = NO;
        scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        scroll.delegate = self;
        scroll;
    });
    self.middleLine = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mline.png"]];
//        [self addSubview:imageView];
        imageView;
    });
    
    _colorInfos = [NSMutableArray array];
    _startColor = NO;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgScrollView.width = self.width;
    self.middleLine.center = self.bgScrollView.center = CGPointMake(self.width/2, self.height/2);
    self.middleLine.bounds = CGRectMake(0, 0, 2, self.height - 30);
}


- (void)setAppearanceConfig:(TCRangeContentConfig *)appearanceConfig
{
    _appearanceConfig = appearanceConfig;
}

- (void)setImageList:(NSArray *)images
{
    if (self.rangeContent) {
        [self.rangeContent removeFromSuperview];
    }
    if (_appearanceConfig) {
        self.rangeContent = [[TCRangeContent alloc] initWithImageList:images config:_appearanceConfig];
    } else {
        self.rangeContent = [[TCRangeContent alloc] initWithImageList:images];
    }
    self.rangeContent.delegate = self;
    
    [self.bgScrollView addSubview:self.rangeContent];
    self.bgScrollView.contentSize = [self.rangeContent intrinsicContentSize];
    self.bgScrollView.height = self.bgScrollView.contentSize.height;
    self.bgScrollView.contentInset = UIEdgeInsetsMake(0, self.width/2-self.rangeContent.pinWidth,
                                                      0, self.width/2-self.rangeContent.pinWidth);
    
    [self setCurrentPos:0];
}

- (void)updateImage:(UIImage *)image atIndex:(NSUInteger)index;
{
    self.rangeContent.imageViewList[index].image = image;
}

- (void)setCenterPanHidden:(BOOL)isHidden
{
    self.rangeContent.centerPin.hidden = isHidden;
}

- (void)setCenterPanFrame:(CGFloat)time
{
    self.rangeContent.centerPinCenterX = time / _durationMs * self.rangeContent.width;
    self.rangeContent.centerPin.center = CGPointMake( self.rangeContent.centerPinCenterX, self.rangeContent.centerPin.center.y);
}

- (void)startColoration:(UIColor *)color alpha:(CGFloat)alpha
{
    VideoColorInfo *info = [[VideoColorInfo alloc]init];
    info.colorView = [UIView new];
    info.colorView.backgroundColor = color;
    info.colorView.alpha = alpha;
    info.colorView.userInteractionEnabled = NO;
    info.startPos = _currentPos;
    [_colorInfos addObject:info];
    
    [self.rangeContent insertSubview:info.colorView belowSubview:self.rangeContent.leftPin];
    _startColor = YES;
}

- (void)stopColoration
{
    VideoColorInfo *info = [_colorInfos lastObject];
    info.endPos = _currentPos;
    _startColor = NO;
}

- (void)removeLastColoration
{
    VideoColorInfo *info = [_colorInfos lastObject];
    [info.colorView removeFromSuperview];
    [_colorInfos removeObject:info];
}

- (void)setDurationMs:(CGFloat)durationMs {
    _durationMs = durationMs;
    _leftPos = 0;
    _rightPos = _durationMs;
    [self setCurrentPos:_currentPos];
    
    _leftPos =  self.durationMs * self.rangeContent.leftScale;
    _centerPos = self.durationMs * self.rangeContent.centerScale;
    _rightPos = self.durationMs * self.rangeContent.rightScale;
}

- (void)setCurrentPos:(CGFloat)currentPos
{
    _currentPos = currentPos;
    if (_durationMs <= 0) {
        return;
    }
    CGFloat off = currentPos * self.rangeContent.imageListWidth / _durationMs;
    //    off += self.rangeContent.leftPin.width;
    off -= self.bgScrollView.contentInset.left;
    
    self.disableSeek = YES;
    self.bgScrollView.contentOffset = CGPointMake(off, 0);
    
    VideoColorInfo *info = [_colorInfos lastObject];
    if (_startColor) {
        CGFloat x = 0;
        if (_currentPos > info.startPos) {
            x = self.rangeContent.pinWidth + info.startPos * self.rangeContent.imageListWidth / _durationMs;
        }else{
            x = self.rangeContent.pinWidth + _currentPos * self.rangeContent.imageListWidth / _durationMs;
        }
        CGFloat width = fabs(_currentPos - info.startPos) * self.rangeContent.imageListWidth / _durationMs;
        info.colorView.frame = CGRectMake(x, 0, width, self.height);
    }
    self.disableSeek = NO;
}

#pragma Delegate -
#pragma TXVideoRangeContentDelegate

- (void)onRangeLeftChanged:(TCRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    
    [self.delegate onVideoRangeLeftChanged:self];
}

- (void)onRangeLeftChangeEnded:(TCRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    
    [self.delegate onVideoRangeLeftChangeEnded:self];
    
}

- (void)onRangeCenterChanged:(TCRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    _centerPos =  self.durationMs * sender.centerScale;
    
    [self.delegate onVideoRangeCenterChanged:self];
}

- (void)onRangeCenterChangeEnded:(TCRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    _centerPos =  self.durationMs * sender.centerScale;
    
    [self.delegate onVideoRangeCenterChangeEnded:self];
}

- (void)onRangeRightChanged:(TCRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    
    [self.delegate onVideoRangeRightChanged:self];
}

- (void)onRangeRightChangeEnded:(TCRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    
    [self.delegate onVideoRangeRightChangeEnded:self];
}

- (void)onRangeLeftAndRightChanged:(TCRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pos = scrollView.contentOffset.x;
    pos += scrollView.contentInset.left;
    if (pos < 0) pos = 0;
    if (pos > self.rangeContent.imageListWidth) pos = self.rangeContent.imageListWidth;
    
    _currentPos = self.durationMs * pos/self.rangeContent.imageListWidth;
    if (self.disableSeek == NO) {
        NSLog(@"seek %f", _currentPos);
        [self.delegate onVideoRange:self seekToPos:self.currentPos];
    }
}
@end


