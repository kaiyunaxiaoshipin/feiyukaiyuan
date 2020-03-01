//
//  TiStickerCell.m
//  TiSDK
//
//  Created by Cat66 on 18/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import "TiStickerCell.h"
#import "TiStickerItem.h"
#import "TiConst.h"
#import "UIImageView+WebCache.h"
#import "TiSDKInterface.h"

static NSString *Ti_STICKER_ICON_DOWNLOADING = @"xiazai.png";
static NSString *Ti_STICKER_ICON_SELECTED = @"ic_border_selected";
static NSString *Ti_STICKER_ICON_NONE = @"cancel.png";
static NSString *Ti_STICKER_ICON_DOWNLOADALL = @"download.png";

@interface TiIndicatorView ()
{
    CALayer *_animationLayer;
}

@end

@implementation TiIndicatorView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tintColor = [UIColor whiteColor];
        _size = 25.0f;
        [self commonInit];
    }
    return self;
}

- (id)initWithTintColor:(UIColor *)tintColor size:(CGFloat)size {
    self = [super init];
    if (self) {
        _size = size;
        _tintColor = tintColor;
        [self commonInit];
    }
    return self;

}

#pragma mark -
#pragma mark Methods

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.hidden = YES;

    _animationLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_animationLayer];

    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)setupAnimation {
    _animationLayer.sublayers = nil;

    [self setupAnimationInLayer:_animationLayer withSize:CGSizeMake(_size, _size) tintColor:_tintColor];
    _animationLayer.speed = 0.0f;

}

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 0.6f;

    // Rotate animation
    CAKeyframeAnimation *rotateAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.rotation.z"];

    rotateAnimation.values = @[@0, @M_PI, @(2 * M_PI)];
    rotateAnimation.duration = duration;
    rotateAnimation.repeatCount = HUGE_VALF;


    // Draw ball clip
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath =
            [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width / 2, size.height / 2) radius:size.width / 2 startAngle:1.5 * M_PI endAngle:M_PI clockwise:true];

    circle.path = circlePath.CGPath;
    circle.lineWidth = 3;
    circle.fillColor = nil;
    circle.strokeColor = tintColor.CGColor;

    circle.frame =
            CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
    [circle addAnimation:rotateAnimation forKey:@"animation"];
    [layer addSublayer:circle];
}

- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.removedOnCompletion = NO;
    return animation;
}

- (void)startAnimating {
    if (!_animationLayer.sublayers) {
        [self setupAnimation];
    }
    self.hidden = NO;
    _animationLayer.speed = 1.0f;
    _animating = YES;
}

- (void)stopAnimating {
    _animationLayer.speed = 0.0f;
    _animating = NO;
    self.hidden = YES;
}

#pragma mark -
#pragma mark Setters

- (void)setSize:(CGFloat)size {
    if (_size != size) {
        _size = size;

        [self setupAnimation];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;

        CGColorRef tintColorRef = tintColor.CGColor;
        for (CALayer *sublayer in _animationLayer.sublayers) {
            sublayer.backgroundColor = tintColorRef;

            if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                shapeLayer.strokeColor = tintColorRef;
                shapeLayer.fillColor = tintColorRef;
            }
        }
    }
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    _animationLayer.frame = self.bounds;

    BOOL animating = _animating;

    if (animating)
        [self stopAnimating];

    [self setupAnimation];

    if (animating)
        [self startAnimating];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_size, _size);
}


@end

@interface TiStickerCell ()

@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UIImageView *downloadView;

@property(nonatomic, strong) UIImageView *backView;

@property(nonatomic, strong) TiSticker *sticker;

@property(nonatomic, strong) TiIndicatorView *indicatorView;

//@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;


@end

@implementation TiStickerCell

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
    }
    return _imgView;

}

- (UIImageView *)downloadView {
    if (!_downloadView) {

        _downloadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Ti_STICKER_ICON_DOWNLOADING]];

        [self.contentView addSubview:_downloadView];
    }
    return _downloadView;
}

- (UIImageView *)backView {
    if (!_backView) {

        _backView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_backView setImage:nil];
    }
    return _backView;

}

- (TiIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView =
                [[TiIndicatorView alloc] initWithTintColor:[UIColor whiteColor] size:self.imgView.frame.size.width - 8];

        [self.contentView addSubview:_indicatorView];

    }
    return _indicatorView;

}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backgroundView = self.backView;

        self.imgView.frame = CGRectMake(6, 6, (CGRectGetWidth(self.frame)) - 10, CGRectGetWidth(self.frame) - 10);

        self.downloadView.frame = CGRectMake(self.bounds.size.width - 13, self.bounds.size.height - 13, 13, 13);

        self.indicatorView.center = self.imgView.center;

    }
    return self;
}

- (void)setSticker:(TiSticker *)sticker index:(NSInteger)index {
    _sticker = sticker;
//    [self.imgView sd_cancelCurrentImageLoad];
    if (index == 0) {
        self.imgView.image = [UIImage imageNamed:Ti_STICKER_ICON_NONE];
        self.downloadView.image = nil;

        if (self.indicatorView.animating == YES) {
            [self.indicatorView stopAnimating];
        }

    } else {
        NSString *str = [NSString stringWithFormat:@"%@%@", [TiSDK getStickerIconURL], sticker.stickerIcon];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [TiSDK getStickerIconURL], sticker.stickerIcon]]];

        self.downloadView.image = [UIImage imageNamed:Ti_STICKER_ICON_DOWNLOADING];

        if (sticker.isDownload == YES) {
            if (self.indicatorView.animating == YES) {
                [self.indicatorView stopAnimating];
            }

            sticker.downloadState = TiStickerDownloadStateDownoadDone;
            self.downloadView.hidden = YES;

        } else {
            if (sticker.downloadState == TiStickerDownloadStateDownoading) {
                self.downloadView.hidden = YES;

                if (self.indicatorView.animating != YES) {
                    [self.indicatorView startAnimating];
                }

            } else {

                if (self.indicatorView.animating == YES) {
                    [self.indicatorView stopAnimating];
                }

                sticker.downloadState = TiStickerDownloadStateDownoadNot;
                self.downloadView.hidden = NO;

            }

        }
    }

}

- (void)startDownload {
    self.sticker.downloadState = TiStickerDownloadStateDownoading;
    self.downloadView.hidden = YES;
    [self.indicatorView startAnimating];

}

- (void)hideBackView:(BOOL)hidden {
    if (hidden) {
        self.backView.image = nil;
    } else {
        self.backView.image = [UIImage imageNamed:Ti_STICKER_ICON_SELECTED];
    }
}

@end
