//
//  JJGainImage.h
//  JJPDF
//
//  Created by Mac on 15/12/16.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJGainImage : NSObject
/*
 * MARK: 获取截图
 */
+ (UIImage *) gainImage:(UIView *) view;
/*
 * MARK: 将image写入文件
 */
+ (NSString *) writeImage:(UIImage *) image;

/*
 * MARK: 保留文件名
 */
+ (NSString *) fileNameWithFilePath:(NSString *) filePath;

@end
