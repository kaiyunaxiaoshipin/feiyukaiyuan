//
//  TiPoint.h
//  TiSDK
//
//  Created by Cat66 on 18/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    TiPositionHair = 1,
    PositionEye = 2,
    TiPositionEar = 3,
    TiPositionNose = 4,
    TiPositionNostril = 5,
    TiPositionUperMouth = 6,
    TiPositionMouth = 7,
    TiPositionLip = 8,
    TiPositionChin = 9,
    PositionEyebrow,
    TiPositionCheek,
    TiPositionNeck,
    TiPositionFace,
} TiPosition;

/**
 返回某位置对应的点
 */
@interface TiPoint : NSObject

@property(nonatomic) int left;
@property(nonatomic) int center;
@property(nonatomic) int right;

+ (instancetype)facePointForPosition:(TiPosition)position;

@end

