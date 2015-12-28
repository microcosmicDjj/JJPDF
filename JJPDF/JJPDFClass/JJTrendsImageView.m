//
//  JJTrendsImageView.m
//  JJPDF
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJTrendsImageView.h"
#import "UIView+LayoutMethods.h"

#define maxImageViewW 200.0
#define maxImageViewH 250.0
@implementation JJTrendsImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void) setupView
{
    self.userInteractionEnabled = YES;
//    self.contentMode = UIViewContentModeScaleToFill;
}

@end
