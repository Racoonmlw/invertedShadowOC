//
//  invertedShadowImage.m
//  invertedShadow
//
//  Created by tjtd12 on 16/1/11.
//  Copyright © 2016年 tjtd12. All rights reserved.
//

#import "invertedShadowImage.h"

@implementation invertedShadowImage

#pragma mark -
#pragma mark Properties

@synthesize image = image_;
@synthesize visibleReflectionHeight = visibleReflectionHeight_;
@synthesize paddingToTopImage = paddingToTopImage_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    
    
    image_ = nil;
    
    visibleReflectionHeight_ = 0.0f;
    
    paddingToTopImage_ = 0.0f;
    
    
    
}

#pragma mark -
#pragma mark Draw methods

/**
 * Draws the receiver’s image within the passed-in rectangle.
 *
 * @param rect: The portion of the view’s bounds that needs to be updated.
 */
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    if (image_ != nil) {
        
        // Get current context to draw.
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Reflection image references
        CGImageRef reflectionImage = NULL;
        CGImageRef gradientImage = NULL;
        
        // Frame of image
        CGRect frame = [self frame];
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        frame.size.width = CGRectGetWidth(frame);
        frame.size.height = image_.size.height * CGRectGetWidth(frame) / image_.size.width;
        
        // Draw initial image in context
        CGContextSaveGState(context);
        {
            
            // Draw image in context, commented but the image show in reverse.
            //            CGContextDrawImage(context, frame, [image_ CGImage]);
            
            // Push context to draw image.
            UIGraphicsPushContext(context);
            
            // Draw original image in top
            [image_ drawInRect:frame];
            
            // Pop to context
            UIGraphicsPopContext();
            
        }
        CGContextRestoreGState(context);
        
        // Create gradient bitmap
        CGContextSaveGState(context);
        {
            
            // Gradient is always black-white and the mask must be in the gray colorspace.
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
            
            // Create a bitmap context
            CGContextRef gradientContext = CGBitmapContextCreate(NULL, CGRectGetWidth(frame), CGRectGetHeight(frame), 8, 0, colorSpace, kCGImageAlphaNone);
            
            // Define the start and the end grayscale values (with the alpha, even though our
            // bitmap context doesn't support alpha gradient requieres it).
            CGFloat colors[] = {0.0f, 1.0f, 1.0f, 1.0f};
            
            // Creates the CGGradient
            CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
            
            // Release colorSpace reference
            CGColorSpaceRelease(colorSpace);
            
            // Create the start and end points for the gradient vector (straight down).
            CGPoint gradientStartPoint = CGPointMake(0, (CGRectGetHeight(frame) - visibleReflectionHeight_));
            CGPoint gradientEndPoint = CGPointMake(0, ((CGRectGetHeight(frame) * 2) - visibleReflectionHeight_));
            
            // Draw gradient into gradient context.
            CGContextDrawLinearGradient(gradientContext, grayScaleGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsAfterEndLocation);
            
            // Release Gradient reference.
            CGGradientRelease(grayScaleGradient);
            
            // Convert the gradient context to image.
            gradientImage = CGBitmapContextCreateImage(gradientContext);
            
            // Release gradient context
            CGContextRelease(gradientContext);
            
        }
        CGContextRestoreGState(context);
        
        // Apply gradient bitmap to new context that contains image.
        CGContextSaveGState(context);
        {
            
            // Create a RGB color space
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            
            // Create bitmap context to join image and gradient context.
            CGContextRef reflectionContext = CGBitmapContextCreate(NULL, CGRectGetWidth(frame), CGRectGetHeight(frame), 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast));
            
            // Release color space
            CGColorSpaceRelease(colorSpace);
            
            // First clip mask to context
            CGContextSaveGState(context);
            {
                
                // Clip gradient mask to reflection context.
                CGContextClipToMask(reflectionContext, frame, gradientImage);
                
            }
            CGContextRestoreGState(context);
            
            // Second draw image to context
            CGContextSaveGState(reflectionContext);
            {
                
                // Push context to draw image.
                UIGraphicsPushContext(reflectionContext);
                
                // Draw original image in top
                [image_ drawInRect:frame];
                
                // Pop to context
                UIGraphicsPopContext();
                
            }
            CGContextRestoreGState(reflectionContext);
            
            // Delete gradient image mask
            CGImageRelease(gradientImage);
            
            // Convert reflection context to image.
            reflectionImage = CGBitmapContextCreateImage(reflectionContext);
            
            // Release reflection context
            CGContextRelease(reflectionContext);
            
        }
        CGContextRestoreGState(context);
        
        // Transform matrix and draw reflection bitmap.
        CGContextSaveGState(context);
        {
            
            // Translate context matrix to height * 2 but next scale and sum 1.0f of image and padding.
            CGContextTranslateCTM(context, CGRectGetMinX(frame), (CGRectGetHeight(frame) * 2) + paddingToTopImage_);
            
            // Flip vertical image in context.
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            // Draw reflection image in context.
            CGContextDrawImage(context, frame, reflectionImage);
            
            // Release reflectio image.
            CGImageRelease(reflectionImage);
            
        }
        CGContextRestoreGState(context);
        
    }
    
}

/**
 * Set current image to another image.
 *
 * @param image: Another image to set.
 */
- (void)setImage:(UIImage *)image {
    
    image_ = image;
    
    
    [self setNeedsDisplay];
    
}

/**
 * Set current visibleReflectioHeight_ value to another.
 *
 * @param gradientStart: Another value to visible reflectio height variable.
 */
- (void)setVisibleReflectionHeight:(CGFloat)visibleReflectioHeight {
    
    if (visibleReflectionHeight_ != visibleReflectioHeight) {
        
        visibleReflectionHeight_ = visibleReflectioHeight;
        
    }
    
    [self setNeedsDisplay];
    
}

/**
 * Set current paddingToTopImage variable to another value.
 *
 * @param paddingToTopImage: Another value to padding to top image.
 */
- (void)setPaddingToTopImage:(CGFloat)paddingToTopImage {
    
    if (paddingToTopImage_ != paddingToTopImage) {
        
        paddingToTopImage_ = paddingToTopImage;
        
    }
    
    [self setNeedsDisplay];
    
}




@end
