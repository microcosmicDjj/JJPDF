//
//  JJPDFAlterImageView.h
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJPDFAlterImageView : UIView

//MARK:设置颜色
@property (nonatomic, strong) UIColor *lineColor;

//MARK:设置线条的宽度
@property (nonatomic) CGFloat lineWidth;

//MARK:图片
@property (nonatomic, strong) UIImage *image;

//MARK:是否清除了记录
@property (nonatomic) BOOL cleanRecord;

/*
 * MARK: 清除一条线
 */
- (void) back;
/*
 * MARK: 全部返回
 */
- (void) allBack;

/*
 * MARK: 添加一个文本框
 */
- (void) addTextView;

/*
 * MARK: 清除一个输入框
 */
- (void) cleanTextView;
/*
 * MARK: 清除所有的输入框
 */
- (void) cleanAllTextView;

/*
 * MARK: 添加一张图片
 */
- (void) addImageView:(UIImage *) image imageFrame:(CGRect) frame;

/*
 * MARK: 清除一张图片
 */
- (void) cleanImageView;
/*
 * MARK: 清除所有图片
 */
- (void) cleanAllImageView;
/*
 * MARK: 保存图片
 */
- (UIImage *) saveImage;

@end
