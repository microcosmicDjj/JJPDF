//
//  JJRedactImageViewController.h
//  JJPDF
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJRedactImageDelegate <NSObject>
@optional
- (void) redactImage:(UIImage *) image imageFrame:(CGRect) frame;

@end

@interface JJRedactImageViewController : UIViewController

/*传入image进行编辑**/
@property (nonatomic, strong) UIImage *image;
/*代理方法**/
@property (nonatomic, weak) id<JJRedactImageDelegate> delegate;

@end
