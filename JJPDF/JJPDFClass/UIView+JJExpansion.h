//
//  UIView+JJExpansion.h
//  JJPDF
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ExpansionBlock)(CGPoint point);
@interface UIView (JJExpansion)

/*
 * MAEK: 普通的
 */
- (void) openExpansionGesticulationBlock:(ExpansionBlock) myblock;
///*
// * MAEK: 适用于uiimageview 不变形的暂时不写

// */
//- (void) openExpansionScaleAspectFillGesticulationBlock:(ExpansionBlock)myblock;
@end
