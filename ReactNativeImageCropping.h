#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import "TOCropView.h"
#import <React/RCTImageLoader.h>
#else
#import "RCTBridgeModule.h"
#import "TOCropView.h"
#import "RCTImageLoader.h"
#endif

@interface ReactNativeImageCropping : NSObject <RCTBridgeModule>

@end
