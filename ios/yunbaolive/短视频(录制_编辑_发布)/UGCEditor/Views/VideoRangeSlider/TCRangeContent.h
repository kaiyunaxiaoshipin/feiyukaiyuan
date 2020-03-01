//
//  TCVideoRangeContent.h
//  SAVideoRangeSliderExample
//
//  Created by annidyfeng on 2017/4/18.
//  Copyright © 2017年 Andrei Solovjev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCVideoRangeConst.h"



@interface TCRangeContentConfig : NSObject
@property (nonatomic) NSInteger pinWidth;
@property (nonatomic) NSInteger thumbHeight;
@property (nonatomic) NSInteger borderHeight;
@property (nonatomic) UIImage*  leftPinImage;
@property (nonatomic) UIImage*  rightPigImage;
@property (nonatomic) UIImage*  leftCorverImage;
@property (nonatomic) UIImage*  rightCoverImage;
@property (nonatomic) UIImage*  centerPinImage;

@end




@protocol TCRangeContentDelegate;

@interface TCRangeContent : UIView

@property (nonatomic, weak) id<TCRangeContentDelegate> delegate;

@property (nonatomic) CGFloat   leftPinCenterX;
@property (nonatomic) CGFloat   rightPinCenterX;
@property (nonatomic) CGFloat   centerPinCenterX;   //中间滑块位置

@property (nonatomic) UIImageView   *leftPin;
@property (nonatomic) UIImageView   *rightPin;
@property (nonatomic) UIView        *topBorder;
@property (nonatomic) UIView        *bottomBorder;
@property (nonatomic) UIImageView   *middleLine;
@property (nonatomic) UIImageView   *centerCover;
@property (nonatomic) UIImageView   *leftCover;
@property (nonatomic) UIImageView   *rightCover;
@property (nonatomic) UIImageView   *centerPin;     //中滑块

@property (nonatomic, copy) NSArray<UIImageView *>       *imageViewList;
@property (nonatomic, copy) NSArray       *imageList;

@property (nonatomic, readonly) CGFloat pinWidth;
@property (nonatomic, readonly) CGFloat imageWidth;
@property (nonatomic, readonly) CGFloat imageListWidth;

@property (nonatomic, readonly) CGFloat leftScale;
@property (nonatomic, readonly) CGFloat rightScale;
@property (nonatomic, readonly) CGFloat centerScale; //中间拉条的位置比例


- (instancetype)initWithImageList:(NSArray *)images;
- (instancetype)initWithImageList:(NSArray *)images config:(TCRangeContentConfig*)config;
- (void)updateLineFrame;
@end


@protocol TCRangeContentDelegate <NSObject>

@optional
- (void)onRangeLeftChangeBegin:(TCRangeContent*)sender;
- (void)onRangeLeftChanged:(TCRangeContent *)sender;
- (void)onRangeLeftChangeEnded:(TCRangeContent *)sender;
- (void)onRangeRightChangeBegin:(TCRangeContent*)sender;
- (void)onRangeRightChanged:(TCRangeContent *)sender;
- (void)onRangeRightChangeEnded:(TCRangeContent *)sender;
- (void)onRangeLeftAndRightChanged:(TCRangeContent *)sender;
- (void)onRangeCenterChangeBegin:(TCRangeContent*)sender;
- (void)onRangeCenterChanged:(TCRangeContent *)sender;
- (void)onRangeCenterChangeEnded:(TCRangeContent *)sender;

@end


