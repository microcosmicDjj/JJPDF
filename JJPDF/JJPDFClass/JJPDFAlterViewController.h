//
//  JJPDFAlterViewController.h
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJPDFAlterViewControllerDalegate <NSObject>
@optional
- (void) alterViewControlleReloaddataImage:(UIImage *) image;
@end

@interface JJPDFAlterViewController : UIViewController

/*传入图片**/
@property (nonatomic, strong) UIImage *image;
/*传入文件名**/
@property (nonatomic, copy) NSString *filePath;
/*传入页数**/
@property (nonatomic) NSInteger page;

@property (nonatomic, weak) id<JJPDFAlterViewControllerDalegate> dalegate;

@end
