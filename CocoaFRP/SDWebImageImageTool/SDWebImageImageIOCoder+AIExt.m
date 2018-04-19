//
//  SDWebImageImageIOCoder+AIExt.m
//  aries
//
//  Created by bloodspasm on 2018/4/18.
//  Copyright © 2018年 Pride_Of_Hiigara. All rights reserved.
//

#import "SDWebImageImageIOCoder+AIExt.h"
#import <SDWebImageCoderHelper.h>
#import <SDWebImageImageIOCoder.h>
#import <objc/runtime.h>
#import <objc/message.h>

#define SDWMaxLength    128 //设置限制
#define SDWMaxWith      640 //设置宽度

@implementation SDWebImageImageIOCoder (AIExt)

//:小布
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (UIImage *)decodedImageWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    UIImage *image = [[UIImage alloc] initWithData:data];
    UIImage *scale = [[UIImage alloc] initWithData:data];
#if SD_MAC
    return image;
#else
    if (!image) {
        return nil;
    }
    image = [[UIImage alloc] initWithData:data];
    if (data.length/1024 > SDWMaxLength) {
        image = [self compressImageWith:image];
    }
    NSData *imageData = UIImagePNGRepresentation(scale);
    UIImageOrientation orientation = [[self class] sd_imageOrientationFromImageData:imageData];
    if (orientation != UIImageOrientationUp) {
        image = [[UIImage alloc] initWithCGImage:image.CGImage scale:image.scale orientation:orientation];
    }
    
    return image;
#endif
}
#pragma clang diagnostic pop
//:小布
- (UIImage *)compressImageWith:(UIImage *)image{
    
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = SDWMaxWith;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
//:小布
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

#if SD_UIKIT || SD_WATCH
#pragma mark EXIF orientation tag converter
+ (UIImageOrientation)sd_imageOrientationFromImageData:(nonnull NSData *)imageData {
    UIImageOrientation result = UIImageOrientationUp;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (imageSource) {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (properties) {
            CFTypeRef val;
            NSInteger exifOrientation;
            val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
            if (val) {
                CFNumberGetValue(val, kCFNumberNSIntegerType, &exifOrientation);
                result = [SDWebImageCoderHelper imageOrientationFromEXIFOrientation:exifOrientation];
            } // else - if it's not set it remains at up
            CFRelease((CFTypeRef) properties);
        } else {
            //NSLog(@"NO PROPERTIES, FAIL");
        }
        CFRelease(imageSource);
    }
    return result;
}
#endif
#pragma clang diagnostic pop

@end
