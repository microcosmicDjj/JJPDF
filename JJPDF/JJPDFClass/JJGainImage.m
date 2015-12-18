//
//  JJGainImage.m
//  JJPDF
//
//  Created by Mac on 15/12/16.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJGainImage.h"

@implementation JJGainImage
/*
 * MARK: 获取截图
 */
+ (UIImage *) gainImage:(UIView *) view
{
//    NSLog(@"%@",NSStringFromCGSize(view.bounds.size));
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
/*
 * MARK: 写入文件
 */
+ (NSString *) writeImage:(UIImage *) image
{
    //保存在沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *dateStr = [NSString stringWithFormat:@"/%d.png",(int)[[NSDate date] timeIntervalSince1970]];
    
    /*文件写入路径**/
    NSString *filePath = [docDir stringByAppendingString:dateStr];
    /*写入文件**/
    NSData *imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:filePath atomically:YES];
    
    return dateStr;
}
/*
 * MARK: 保留文件名
 */
+ (NSString *) fileNameWithFilePath:(NSString *) filePath
{
    NSArray *filePaths = [filePath componentsSeparatedByString:@"/"];
    
    NSString *fileName = filePaths.lastObject;

    return fileName;
}

@end
