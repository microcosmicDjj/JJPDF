//
//  JJPDFAlterModel.h
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJPDFAlterModel : NSObject

/*设置颜色**/
@property (nonatomic, strong) UIColor *lineColor;
/*记录点的位置**/
@property (nonatomic, strong) NSMutableArray *linePoints;
/*设置线条的宽度**/
@property (nonatomic) CGFloat lineWidth;

@end
