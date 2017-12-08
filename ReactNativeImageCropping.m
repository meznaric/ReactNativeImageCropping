#import "ReactNativeImageCropping.h"
#import <UIKit/UIKit.h>
#import "TOCropViewController.h"

@interface ReactNativeImageCropping () <TOCropViewControllerDelegate>

@property (nonatomic, strong) RCTPromiseRejectBlock _reject;
@property (nonatomic, strong) RCTPromiseResolveBlock _resolve;
@property TOCropViewControllerAspectRatio aspectRatio;
@property NSNumber* compressionQuality;


@end

@implementation RCTConvert (AspectRatio)
RCT_ENUM_CONVERTER(TOCropViewControllerAspectRatio, (@{
            @"AspectRatioOriginal" : @(TOCropViewControllerAspectRatioOriginal),
              @"AspectRatioSquare" : @(TOCropViewControllerAspectRatioSquare),
                 @"AspectRatio3x2" : @(TOCropViewControllerAspectRatio3x2),
                 @"AspectRatio5x3" : @(TOCropViewControllerAspectRatio5x3),
                 @"AspectRatio4x3" : @(TOCropViewControllerAspectRatio4x3),
                 @"AspectRatio5x4" : @(TOCropViewControllerAspectRatio5x4),
                 @"AspectRatio7x5" : @(TOCropViewControllerAspectRatio7x5),
                @"AspectRatio16x9" : @(TOCropViewControllerAspectRatio16x9)
                }), UIStatusBarAnimationNone, integerValue)
@end

@implementation ReactNativeImageCropping

RCT_EXPORT_MODULE()


@synthesize bridge = _bridge;

- (NSDictionary *)constantsToExport
{
    return @{
   @"AspectRatioOriginal" : @(TOCropViewControllerAspectRatioOriginal),
     @"AspectRatioSquare" : @(TOCropViewControllerAspectRatioSquare),
        @"AspectRatio3x2" : @(TOCropViewControllerAspectRatio3x2),
        @"AspectRatio5x3" : @(TOCropViewControllerAspectRatio5x3),
        @"AspectRatio4x3" : @(TOCropViewControllerAspectRatio4x3),
        @"AspectRatio5x4" : @(TOCropViewControllerAspectRatio5x4),
        @"AspectRatio7x5" : @(TOCropViewControllerAspectRatio7x5),
       @"AspectRatio16x9" : @(TOCropViewControllerAspectRatio16x9),
    };
}

RCT_EXPORT_METHOD(  cropImageWithUrl:(NSString *)imageUrl
                    resolver:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject

)
{
    self._reject = reject;
    self._resolve = resolve;
    self.aspectRatio = NULL;
    self.compressionQuality = NULL;

    
    NSURLRequest *imageUrlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    
    [self.bridge.imageLoader loadImageWithURLRequest:imageUrlrequest callback:^(NSError *error, UIImage *image) {
        if(error) reject(@"100", @"Failed to load image", error);
        if(image) {
            [self handleImageLoad:image];
        }
    }];
}

RCT_EXPORT_METHOD(  cropImageWithUrlAndJPGCompression:(NSString *)imageUrl
                    compressionQuality:(nonnull NSNumber *)compressionQuality
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  
                  )
{
    self._reject = reject;
    self._resolve = resolve;
    self.aspectRatio = NULL;
    self.compressionQuality = compressionQuality;
    
    NSURLRequest *imageUrlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    
    [self.bridge.imageLoader loadImageWithURLRequest:imageUrlrequest callback:^(NSError *error, UIImage *image) {
        if(error) reject(@"100", @"Failed to load image", error);
        if(image) {
            [self handleImageLoad:image];
        }
    }];
}

RCT_EXPORT_METHOD(cropImageWithUrlAndAspect:(NSString *)imageUrl
                                aspectRatio:(TOCropViewControllerAspectRatio)aspectRatio
                                   resolver:(RCTPromiseResolveBlock)resolve
                                   rejecter:(RCTPromiseRejectBlock)reject
        )
{
    self._reject = reject;
    self._resolve = resolve;
    self.aspectRatio = aspectRatio;
    self.compressionQuality = NULL;
    
    NSURLRequest *imageUrlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    
    [self.bridge.imageLoader loadImageWithURLRequest:imageUrlrequest callback:^(NSError *error, UIImage *image) {
        if(error) reject(@"100", @"Failed to load image", error);
        if(image) {
            [self handleImageLoad:image];
        }
    }];

}

- (void)handleImageLoad:(UIImage *)image {
    
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    
    if(self.aspectRatio) {
        cropViewController.lockedAspectRatio = YES;
        cropViewController.defaultAspectRatio = self.aspectRatio;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [root presentViewController:cropViewController animated:YES completion:nil];
    });
}

/**
 Called when the user has committed the crop action, and provides both the original image with crop co-ordinates.
 
 @param image The newly cropped image.
 @param cropRect A rectangle indicating the crop region of the image the user chose (In the original image's local co-ordinate space)
 */
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [cropViewController dismissViewControllerAnimated:YES completion:nil];
    });
    
    
    NSData *imageRepData = NULL;
    NSString *crop_file_name = @"memegenerator-crop-%lf.png";
    if(self.compressionQuality != NULL){
        imageRepData = UIImageJPEGRepresentation(image, self.compressionQuality.floatValue);
        crop_file_name = @"memegenerator-crop-%lf.jpg";
    }else{
        imageRepData = UIImagePNGRepresentation(image);
    }
   
    NSString *fileName = [NSString stringWithFormat:crop_file_name, [NSDate timeIntervalSinceReferenceDate]];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName]; //Add the file name)
    [imageRepData writeToFile:filePath atomically:YES];
    NSNumber *width  = [NSNumber numberWithFloat:image.size.width];
    NSNumber *height = [NSNumber numberWithFloat:image.size.height];
    
    NSDictionary * imageData = @{
                             @"uri":filePath,
                             @"width":width,
                             @"height":height
                             };
    self._resolve(imageData);
}
/**
 If implemented, when the user hits cancel, or completes a UIActivityViewController operation, this delegate will be called,
 giving you a chance to manually dismiss the view controller
 
 */
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [cropViewController dismissViewControllerAnimated:YES completion:nil];
    });
    self._reject(@"400", @"Cancelled", [NSError errorWithDomain:@"Cancelled" code:400 userInfo:NULL]);
}
@end
