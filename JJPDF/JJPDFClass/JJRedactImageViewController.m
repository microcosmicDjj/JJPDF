//
//  JJRedactImageViewController.m
//  JJPDF
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJRedactImageViewController.h"
#import "UIView+LayoutMethods.h"
#import "UIView+JJMoveView.h"
#import "JJPDFViewConstant.h"
#import "JJGainImage.h"
#import "UIView+JJExpansion.h"

#define SIZE_MIN 50.0
@interface JJRedactImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *moveImageView;
@property (nonatomic) CGFloat scaleImageView;
//@property (nonatomic, strong) NSMutableArray *moveImageViews;

@end

@implementation JJRedactImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupImageView];
    [self setupMoveView];
}

- (void) setupImageView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    //计算大小
    _scaleImageView = _image.size.height/_image.size.width;
    
    CGFloat imageViewWidth = rect.size.width;
    CGFloat imageViewHigth = imageViewWidth * _scaleImageView;
    
    if (imageViewHigth >= rect.size.height) {
        imageViewHigth = rect.size.height;
        imageViewWidth = imageViewHigth / _scaleImageView;
    }
    
    self.imageView.frame = CGRectMake(0, 0, imageViewWidth,imageViewHigth);
    self.imageView.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    
    [self.view insertSubview:self.imageView atIndex:0];
}


/*
 * MARK: 初始化MoveView 添加手势
 */
- (void) setupMoveView
{
    [self.imageView addSubview:self.moveImageView];
    [self.moveImageView openMove:^(CGPoint point) {
    }];
  
//    __weak typeof(self) weakSelf = self;
    [self.moveImageView openExpansionGesticulationBlock:^(CGPoint point) {
    }];
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
 * MARK: 截图思密达
 */
- (IBAction)save:(id)sender {
    
    CGFloat imageScaleW = _imageView.image.size.width / _imageView.width;
    CGFloat imageScaleH = _imageView.image.size.height / _imageView.height;
    
    CGRect imageFrame;
    imageFrame.origin.x = self.moveImageView.x * imageScaleW;
    imageFrame.origin.y = self.moveImageView.y * imageScaleH;
    imageFrame.size.width = self.moveImageView.width * imageScaleW;
    imageFrame.size.height = self.moveImageView.height * imageScaleH;
    
//    _imageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([_imageView.image CGImage], imageFrame)];
    UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([_imageView.image CGImage], imageFrame)];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    [self.view addSubview:imageView];
    
    
    NSLog(@"%@",NSStringFromCGRect(imageFrame));

    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.delegate redactImage:image imageFrame:weakSelf.moveImageView.frame];
    }];
}

/*
 * MARK: 懒加载
 */
- (UIImageView *) imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = _image;
        _imageView.center = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
    }
    return _imageView;
}

- (UIImageView *) moveImageView
{
    if (!_moveImageView) {
        UIImage *image = [JJGainImage resizeWithImageName:@"裁剪-自由裁剪"];
        
        _moveImageView = [[UIImageView alloc] initWithImage:image];
        _moveImageView.frame = CGRectMake(0, 0, 100,100);
        _moveImageView.center = CGPointMake(self.imageView.size.width/2,self.imageView.size.height/2);
    }
    return _moveImageView;
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = _image;
}

@end
