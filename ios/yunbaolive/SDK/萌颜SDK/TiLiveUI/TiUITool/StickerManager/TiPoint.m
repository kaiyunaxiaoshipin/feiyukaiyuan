//
//  TiPoint.mm
//  TiSDK
//
//  Created by Cat66 on 18/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import "TiPoint.h"

#define USE_ST_TRACKER 0

@implementation TiPoint

- (instancetype)initWithLeft:(int)leftPoint center:(int)centerPoint right:(int)rightCenter {
    self = [super init];
    if (self) {
        _left = leftPoint;
        _center = centerPoint;
        _right = rightCenter;
    }

    return self;
}

+ (instancetype)pointWithLeft:(int)leftPoint center:(int)centerPoint right:(int)rightCenter {
    return [[self alloc] initWithLeft:leftPoint center:centerPoint right:rightCenter];
}

+ (instancetype)facePointForPosition:(TiPosition)position {
    TiPoint *fp = nil;
    
    switch (position) {
        case PositionEye:
            fp = [TiPoint pointWithLeft:36 center:28 right:45];
            break;

        case TiPositionEar:
            fp = [TiPoint pointWithLeft:36 center:28 right:45];
            break;

        case TiPositionNose:
            fp = [TiPoint pointWithLeft:31 center:30 right:35];
            break;

        case TiPositionNostril:
            fp = [TiPoint pointWithLeft:32 center:33 right:34];
            break;

        case TiPositionUperMouth:
            fp = [TiPoint pointWithLeft:61 center:62 right:63];
            break;

        case TiPositionMouth:
            fp = [TiPoint pointWithLeft:48 center:66 right:54];
            break;

        case TiPositionChin:
            fp = [TiPoint pointWithLeft:48 center:57 right:54];
            break;

        case TiPositionCheek:
        case TiPositionHair:
        case PositionEyebrow:
        case TiPositionFace:
        case TiPositionNeck:
        case TiPositionLip:
        default:
            fp = [TiPoint pointWithLeft:4 center:58 right:14];
            break;
    }

    return fp;
}

@end
