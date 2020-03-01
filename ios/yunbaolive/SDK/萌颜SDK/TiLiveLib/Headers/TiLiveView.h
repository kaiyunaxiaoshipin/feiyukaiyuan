//
//  TiView.h
//  TiTest
//
//  Created by Husky Cooper on 2018/7/13.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiLiveView : UIView

typedef enum TiPixelFormatType {
    kCV_BGRA = kCVPixelFormatType_32BGRA,
    kCV_420v = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
    kCV_420f = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
} TiPixelFormatType;

- (void)setupPreview:(TiPixelFormatType)type;
- (void)startPreview:(CVPixelBufferRef)pixelBuffer isMirror:(BOOL)isMirror;

@end
