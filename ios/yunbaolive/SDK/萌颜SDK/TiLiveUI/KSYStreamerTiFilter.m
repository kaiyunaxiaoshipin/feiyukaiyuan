#import "KSYStreamerTiFilter.h"
#import "TiSDKInterface.h"

@interface KSYStreamerTiFilter () {
}

@property KSYGPUPicOutput *pipOut;
@property(nonatomic, strong) TiSDKManager *tiSDKManager;

@end

@implementation KSYStreamerTiFilter

- (id)initTiSDK:(TiSDKManager *)tiSDKManager {
    self = [super initWithFmt:kCVPixelFormatType_32BGRA];

    self.tiSDKManager = tiSDKManager;

    if (self) {
        _pipOut = [[KSYGPUPicOutput alloc] initWithOutFmt:kCVPixelFormatType_32BGRA];

        __weak KSYStreamerTiFilter *weak_filter = self;

        _pipOut.videoProcessingCallback = ^(CVPixelBufferRef pixelBuffer, CMTime timeInfo) {
          [weak_filter renderTiSDK:pixelBuffer timeInfo:timeInfo];
        };
    }
    return self;
}

#pragma mark - Render CallBack
- (void)renderTiSDK:(CVPixelBufferRef)pixelBuffer timeInfo:(CMTime)timeInfo {
    BOOL isMirror = NO;

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation orie;
    TiRotationEnum rotation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            rotation = CLOCKWISE_90;
            orie = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            rotation = isMirror ? CLOCKWISE_180 : CLOCKWISE_0;
            orie = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            rotation = isMirror ? CLOCKWISE_0 : CLOCKWISE_180;
            orie = UIInterfaceOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotation = CLOCKWISE_270;
            orie = UIInterfaceOrientationPortraitUpsideDown;
            break;
        default:
            rotation = CLOCKWISE_90;
            orie = UIInterfaceOrientationPortrait;
            break;
    }

    // 视频帧格式
    TiImageFormatEnum format;
    switch (CVPixelBufferGetPixelFormatType(pixelBuffer)) {
        case kCVPixelFormatType_32BGRA:
            format = BGRA;
            break;
        case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
            format = NV12;
            break;
        case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
            format = NV12;
            break;
        default:
            NSLog(@"错误的视频帧格式！");
            format = BGRA;
            break;
    }

    int imageWidth, imageHeight;
    if (format == BGRA) {
        imageWidth = (int)CVPixelBufferGetBytesPerRow(pixelBuffer) / 4;
        imageHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    } else {
        imageWidth = (int)CVPixelBufferGetWidthOfPlane(pixelBuffer, 0);
        imageHeight = (int)CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
    }

    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    //            unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    /////////////////// TiFaceSDK 添加 开始 ///////////////////
    [self.tiSDKManager renderPixels:baseAddress
                             Format:format
                              Width:imageWidth
                             Height:imageHeight
                           Rotation:CLOCKWISE_0     //rk_rotation
                             Mirror:isMirror];
    /////////////////// TiFaceSDK 添加 结束 ///////////////////
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    [self processPixelBuffer:pixelBuffer time:timeInfo];
    //    [self processSampleBuffer:pixelBuffer];
}

- (void)dealloc {
    if (self.tiSDKManager != nil)
        [self.tiSDKManager destroy];
}

//#pragma GPUImageInput
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex {
    [_pipOut newFrameReadyAtTime:frameTime atIndex:textureIndex];
}

- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex {
    [_pipOut setInputFramebuffer:newInputFramebuffer atIndex:textureIndex];
}

- (NSInteger)nextAvailableTextureIndex {
    return 0;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [_pipOut setInputSize:newSize atIndex:textureIndex];
}

- (void)setInputRotation:(GPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex {
    [_pipOut setInputRotation:newInputRotation atIndex:textureIndex];
}

- (GPUImageRotationMode)getInputRotation {
    return [_pipOut getInputRotation];
}

- (CGSize)maximumOutputSize {
    return [_pipOut maximumOutputSize];
}

- (void)endProcessing {
}

- (BOOL)shouldIgnoreUpdatesToThisTarget {
    return NO;
}

- (BOOL)wantsMonochromeInput {
    return NO;
}

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue {
}

@end
