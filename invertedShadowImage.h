//
//  invertedShadowImage.h
//  invertedShadow
//
//  Created by tjtd12 on 16/1/11.
//  Copyright © 2016年 tjtd12. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface invertedShadowImage : UIView


{
@private
    
    UIImage *image_;
    
    /**
     * Value of gradient start. This value is divided to height of image.
     */
    CGFloat visibleReflectionHeight_;
    
    /**
     * Padding to top image.
     */
    CGFloat paddingToTopImage_;
}

@property (nonatomic, readwrite, retain) UIImage *image;
@property (nonatomic, readwrite, assign) CGFloat visibleReflectionHeight;
@property (nonatomic, readwrite, assign) CGFloat paddingToTopImage;


@end
