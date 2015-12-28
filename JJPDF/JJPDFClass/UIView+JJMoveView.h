//
//  UIView+JJMoveView.h
//  JJPDF
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MoveViewBlock)(CGPoint point);

@interface UIView (JJMoveView)

- (void) openMove:(MoveViewBlock) block;
//限制约束
- (void) astrict;
@end
