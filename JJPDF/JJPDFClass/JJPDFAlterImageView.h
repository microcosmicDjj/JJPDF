//
//  JJPDFAlterImageView.h
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJPDFAlterImageView : UIView

/*设置颜色**/
@property (nonatomic, strong) UIColor *lineColor;

/*设置线条的宽度**/
@property (nonatomic) CGFloat lineWidth;

/*图片**/
@property (nonatomic, strong) UIImage *image;

/*返回一条线**/
- (void) back;
/*全部返回**/
- (void) allBack;

@end
