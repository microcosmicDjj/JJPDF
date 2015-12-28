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
 * MARK: 获取view的全屏截图
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
    NSString *docDir = [self documentDirectoryStr];
    
    NSString *dateStr = [NSString stringWithFormat:@"/%d.png",(int)[[NSDate date] timeIntervalSince1970]];
    
    /*文件写入路径**/
    NSString *filePath = [docDir stringByAppendingString:dateStr];
    /*写入文件**/
    NSData *imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:filePath atomically:YES];
    
    return dateStr;
}

+ (NSString *) documentDirectoryStr
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath=[NSString stringWithFormat:@"%@/pdfImage",pathDocuments];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else {
    }
    return createPath;
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

//返回一个可拉伸的图片
+ (UIImage *)resizeWithImageName:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    
    CGFloat w = normal.size.width*0.5;
    CGFloat h = normal.size.height*0.5;
    //传入上下左右不需要拉升的编剧，只拉伸中间部分
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

@end
