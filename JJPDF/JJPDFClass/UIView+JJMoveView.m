//
//  UIView+JJMoveView.m
//  JJPDF
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "UIView+JJMoveView.h"
#import "UIView+LayoutMethods.h"

@implementation UIView (JJMoveView)
MoveViewBlock _block;

- (void) openMove:(MoveViewBlock)block
{
    self.userInteractionEnabled = YES;
    self.superview.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(JJ_MoveView:)];
    [self addGestureRecognizer:pan];
    _block = block;
}

- (void) JJ_MoveView:(UIPanGestureRecognizer *) tap
{
    CGPoint translation = [tap translationInView:self];
    
    tap.view.centerX = tap.view.center.x + translation.x;
    tap.view.centerY = tap.view.center.y + translation.y;
    [tap setTranslation:CGPointZero inView:self];
    
    _block(tap.view.center);
    //限制约束
    [self astrict];
}

//限制约束
- (void) astrict
{
    if(self.x < 0){
        self.x = 0;
    }
    if(self.y < 0){
        self.y = 0;
    }
    if (self.width + self.x > self.superview.width) {
        self.x = self.superview.width - self.width;
    }
    if (self.height + self.y > self.superview.height) {
        self.y = self.superview.height - self.height;
    }
}


@end
