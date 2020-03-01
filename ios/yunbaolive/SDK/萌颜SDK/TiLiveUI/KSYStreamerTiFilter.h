#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>
#import <libksygpulive/libksystreamerengine.h>

#import "TiSDKInterface.h"

@interface KSYStreamerTiFilter : KSYGPUPicInput<GPUImageInput>

- (id)initTiSDK:(TiSDKManager *)tiSDKManager;

@end
