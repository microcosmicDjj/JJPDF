//
//  JJPDFMainViewController.m
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJPDFMainViewController.h"
#import "JJPDFShowViewController.h"
#import "JJPDFAlterImageView.h"
#import "JJGainImage.h"
#import "JJPDFAlterViewController.h"
#import "PDFAlterRecordTabel.h"
#import "MyCoreData.h"

@interface JJPDFMainViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,JJPDFAlterViewControllerDalegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic) CGPDFDocumentRef pdfDocument;

/*当前页**/
@property (nonatomic) NSInteger pageIndex;

/*最大的页数**/
@property (nonatomic) NSInteger maxPage;
/*初始化数据操作类**/
@property (nonatomic, strong) MyCoreData *coreData;

@end

@implementation JJPDFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view.frame = rect;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pageViewController.view];
    
    _pageIndex = 1;
    
    [self setupPageViewController];
    [self setupBtn];
}

- (void) setupPageViewController
{
    //得到CGPDFDocumentRef
    CFURLRef pdfURL = CFURLCreateWithFileSystemPathRelativeToBase(kCFAllocatorDefault, (__bridge CFStringRef) _filePath, kCFURLPOSIXPathStyle, true, NULL);
    _pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    CFRelease(pdfURL);
    //最后页数
    _maxPage = CGPDFDocumentGetNumberOfPages(_pdfDocument);
    
    JJPDFShowViewController *pdfShowVC = [self PDFShowViewControllerFrameIndex:_pageIndex];
    
    NSArray *pages = @[pdfShowVC];
    [self.pageViewController setViewControllers:pages direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    }];
    
}

/*
 * MARK:设置uibutton
 */
- (void) setupBtn
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.frame = CGRectMake(rect.size.width - 80, 10, 60, 60);
    [self.view addSubview:btn];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
}

//MARK:进入编辑界面
- (void) btnTouch:(UIButton *) btn
{
    UIImage *image = [JJGainImage gainImage:[self PDFShowViewControllerFrameIndex:_pageIndex].view];
    JJPDFAlterViewController *pdfAlterVC = [[JJPDFAlterViewController alloc] init];
    pdfAlterVC.dalegate = self;
    pdfAlterVC.image = image;
    pdfAlterVC.page = _pageIndex;
    pdfAlterVC.filePath = _filePath;
    pdfAlterVC.pdfDocument = _pdfDocument;
    
    [self presentViewController:pdfAlterVC animated:YES completion:^{
        
    }];
}

/*
 *  pdfaltervc代理方法
 */
- (void) alterViewControlleReloaddataImage:(UIImage *) image
{
    JJPDFShowViewController *showVC = self.pageViewController.viewControllers.lastObject;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = showVC.view.bounds;
    [showVC.view addSubview:imageView];
}

/*
 *  MARK:pageViewController代理
 */
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{

    JJPDFShowViewController *showVC = (JJPDFShowViewController *)viewController;
    if (showVC.page < 2) {
        return nil;
    }
    _pageIndex = showVC.page - 1;
    return [self PDFShowViewControllerFrameIndex:(showVC.page - 1)];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    JJPDFShowViewController *showVC = (JJPDFShowViewController *)viewController;

    if (showVC.page >= _maxPage) {
        return nil;
    }
    _pageIndex = showVC.page + 1;
    return [self PDFShowViewControllerFrameIndex:(showVC.page + 1)];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    JJPDFShowViewController *showVc = (JJPDFShowViewController *)previousViewControllers.lastObject;
//当completed = NO时，表示翻页并没有成功，所以将_pageIndex 重置为初始值，避免bug
    if (!completed) {
        _pageIndex = showVc.page;
    }
    NSLog(@"showVc.page = %ld  completed = %d",showVc.page,completed);
}

/*
 * MARK: 初始化一个JJPDFShowViewController
 */
- (JJPDFShowViewController *) PDFShowViewControllerFrameIndex:(NSInteger) index
{
    JJPDFShowViewController *pdfVC = [[JJPDFShowViewController alloc] init];
    
    NSArray *tabels = [self.coreData selectObject:@"PDFAlterRecordTabel" condition:[NSPredicate predicateWithFormat:@"pdfFilePath = %@ and pdfPage = %@",[JJGainImage fileNameWithFilePath:_filePath],[NSNumber numberWithInteger:index]]];

    if (tabels.count > 0) {
        PDFAlterRecordTabel *tabel = tabels.lastObject;

        NSString *docDir = [JJGainImage documentDirectoryStr];

        NSLog(@"%@",[docDir stringByAppendingString:tabel.pdfImageFilePath]);
        //通过文件名
        UIImage *image = [UIImage imageWithContentsOfFile:[docDir stringByAppendingString:tabel.pdfImageFilePath]];

        pdfVC.image = image;
        pdfVC.page = index;
        pdfVC.pdfView.hidden = YES;
    } else{
        pdfVC.pdfDocument = _pdfDocument;
        pdfVC.page = index;
        pdfVC.pdfView.hidden = NO;
    }
    
    return pdfVC;
}

/*
 * MARK: 懒加载
 */
- (UIPageViewController *) pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

- (MyCoreData *) coreData
{
    if (!_coreData) {
        _coreData = [[MyCoreData alloc] init];
    }
    return _coreData;
}

@end
