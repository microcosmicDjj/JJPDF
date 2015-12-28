//
//  UIView+JJExpansion.m
//  JJPDF
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "UIView+JJExpansion.h"
#import "UIView+LayoutMethods.h"

#define SIZE_MIN 50

@implementation UIView (JJExpansion)

ExpansionBlock _myblock;

- (void) openExpansionGesticulationBlock:(ExpansionBlock) myblock
{
    _myblock = myblock;
    
    for (int i = 0;i < 4; i++) {
        UIView *moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        moveView.backgroundColor = [UIColor redColor];
        moveView.tag = i;
        [self setupFrameMoveView:moveView];
        [self addSubview:moveView];
        
        UIPanGestureRecognizer *zer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesturerecogniTap:)];
        [moveView addGestureRecognizer:zer];
    }
}

/*
 * MARK:扩大和缩小
 */
- (void) panGesturerecogniTap:(UIPanGestureRecognizer *) tap
{
    CGPoint translation = [tap translationInView:tap.view];
    tap.view.center = CGPointMake(tap.view.center.x + translation.x,
                                  tap.view.center.y + translation.y);
    
    [tap setTranslation:CGPointZero inView:tap.view];
        
    CGFloat moveViewX = 0.0;
    CGFloat moveViewY = 0.0;
    CGFloat moveViewWidth = 0.0;
    CGFloat moveViewHigth = 0.0;
    
    if(tap.view.tag == 0){
        moveViewX = self.x + translation.x;
        moveViewY = self.y + translation.y;
        moveViewWidth = self.width - translation.x;
        moveViewHigth = self.height - translation.y;
        if(moveViewHigth < SIZE_MIN){
            moveViewY = self.y;
        }
        if(moveViewWidth < SIZE_MIN){
            moveViewX = self.x;
        }
        if(moveViewX < 0){
            moveViewX = 0;
            moveViewWidth = self.width;
        }
        if(moveViewY < 0){
            moveViewY = 0;
            moveViewHigth = self.height;
        }
    }
    if(tap.view.tag == 1){
        float y = self.height + self.y;
        moveViewWidth = self.width + translation.x;
        moveViewHigth = self.height - translation.y;
        moveViewY = y - moveViewHigth;
        moveViewX = self.x;
        if(moveViewHigth < SIZE_MIN){
            moveViewX = self.y;
        }
        if (moveViewX+moveViewWidth>self.superview.width) {
            moveViewWidth = self.width;
        }
        if (moveViewY < 0) {
            moveViewY = 0;
            moveViewHigth = self.height;
        }
    }
    if(tap.view.tag == 2){
        float x = self.x + self.width;
        moveViewWidth = self.width - translation.x;
        moveViewHigth = self.height + translation.y;
        moveViewX = x - moveViewWidth;
        moveViewY = self.y;
        if(moveViewWidth < SIZE_MIN){
            moveViewX = self.x;
        }
        
        if(moveViewY+moveViewHigth>self.superview.height){
            moveViewHigth = self.height;
        }
        if(moveViewX < 0){
            moveViewX = 0;
            moveViewWidth = self.width;
        }
    }
    if(tap.view.tag == 3){
        moveViewX = self.x;
        moveViewY = self.y;
        moveViewWidth = self.width + translation.x;
        moveViewHigth = self.height + translation.y;
        if(moveViewY+moveViewHigth>self.superview.height){
            moveViewHigth = self.height;
        }
        if (moveViewX+moveViewWidth>self.superview.width) {
            moveViewWidth = self.width;
        }
    }
    
    self.x = moveViewX;
    self.y = moveViewY;
    self.width = moveViewWidth;
    self.height = moveViewHigth;
    
    for (UIView *view in self.subviews) {
        [self setupFrameMoveView:view];
    }
    if(self.width < SIZE_MIN){
        self.width = SIZE_MIN;
    }
    if(self.height < SIZE_MIN){
        self.height = SIZE_MIN;
    }
    
    _myblock(tap.view.center);
}

///*
// * MAEK: uiimageview 不变形的
// */
//- (void) openExpansionScaleAspectFillGesticulationBlock:(ExpansionBlock)myblock
//{
//    for (int i = 0;i<4;i++) {
//        NSMutableArray *viewArr = [self moveViews];
//        UIView *moveView = viewArr[i];
//        moveView.backgroundColor = [UIColor redColor];
//        moveView.tag = i;
//        [self setupFrameMoveView:moveView];
//        [self addSubview:moveView];
//        
//        UIPanGestureRecognizer *zer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(expansionScaleAspectFill:)];
//        [moveView addGestureRecognizer:zer];
//    }
//}
//
//- (void) expansionScaleAspectFill:(UIPanGestureRecognizer *) tap
//{
//    CGPoint translation = [tap translationInView:tap.view];
//    tap.view.center = CGPointMake(tap.view.center.x + translation.x,
//                                  tap.view.center.y + translation.y);
//    
//    [tap setTranslation:CGPointZero inView:tap.view];
//    
//    CGFloat moveViewX = 0.0;
//    CGFloat moveViewY = 0.0;
//    CGFloat moveViewWidth = 0.0;
//    CGFloat moveViewHigth = 0.0;
//    
//    if (tap.view.tag == 0) {
//        
//    } else if (tap.view.tag == 1) {
//    
//    } else if (tap.view.tag == 2) {
//    
//    } else if (tap.view.tag == 3) {
//    
//    }
//    
//    _myblock(tap.view.center);
//}

- (void) setupFrameMoveView:(UIView *) moveView
{
    switch (moveView.tag) {
        case 0:
            moveView.x = 0;
            moveView.y = 0;
            break;
        case 1:
            moveView.x = self.width-20;
            moveView.y = 0;
            break;
        case 2:
            moveView.x = 0;
            moveView.y = self.height-20;
            break;
        case 3:
            moveView.x = self.width-20;
            moveView.y = self.height-20;
            break;
        default:
            break;
    }
    
}
@end
