//
//  ViewController.m
//  invertedShadow
//
//  Created by tjtd12 on 16/1/11.
//  Copyright © 2016年 tjtd12. All rights reserved.
//

#import "ViewController.h"
#import "invertedShadowImage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


-(void)createUI
{
    invertedShadowImage *shadow = [[invertedShadowImage alloc] initWithFrame:CGRectMake(0, 64, 320, 420)];
    
    [shadow setBackgroundColor:[UIColor clearColor]];
    
    //set the padding of top image and its reflected image
    [shadow setPaddingToTopImage:0.0f];
    
    // Hide 1/4 parts of image. show 3/4
    [shadow setVisibleReflectionHeight:(CGRectGetWidth([shadow frame]) / 4 * 2)];
    
    [shadow setImage:[UIImage imageNamed:@"ftue_travel_bk_0.jpg"]];
    
    [self.view addSubview:shadow];
    //将子视图放到最上层

    
}

@end
