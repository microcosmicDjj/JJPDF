//
//  JJPDFAlterViewController.m
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJPDFAlterViewController.h"
#import "JJPDFAlterImageView.h"
#import "PDFAlterRecordTabel.h"
#import "JJGainImage.h"
#import "MyCoreData.h"
#import "JJTrendsTextView.h"

@interface JJPDFAlterViewController ()

@property (weak, nonatomic) IBOutlet JJPDFAlterImageView *pdfAlterImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) MyCoreData *coreData;
@property (strong, nonatomic) NSMutableArray *trendsTextViews;

@end

@implementation JJPDFAlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view.frame = rect;
    
    _pdfAlterImageView.image = _image;
    _pdfAlterImageView.frame = self.view.bounds;
    
    NSLog(@"_pdfAlterImageView.frame = %@",NSStringFromCGRect(_pdfAlterImageView.frame));
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [_pdfAlterImageView addGestureRecognizer:tap];
}

/*
 *  MARK:点击响应
 */
- (void) tapGestureRecognizer:(UITapGestureRecognizer *) tap
{
    if (tap.view.tag == 0) {
        //NSLayoutConstraint 的动画方法，丫的搞这么麻烦
        _headLayoutConstraint.constant = 0;
        _bottomLayoutConstraint.constant = 0;
        [_bottomView setNeedsUpdateConstraints];
        [_headView setNeedsUpdateConstraints];
        
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25f animations:^{
            [weakSelf.bottomView layoutIfNeeded];
            [weakSelf.headView layoutIfNeeded];
        }];

        tap.view.tag = 1;
    } else if (tap.view.tag == 1)
    {
        //NSLayoutConstraint 的动画方法，丫的搞这么麻烦
        _headLayoutConstraint.constant = -49;
        _bottomLayoutConstraint.constant = -64;
        
        [_bottomView setNeedsUpdateConstraints];
        [_headView setNeedsUpdateConstraints];
        
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25f animations:^{
            [weakSelf.bottomView layoutIfNeeded];
            [weakSelf.headView layoutIfNeeded];
        }];
        tap.view.tag = 0;
    }
}
//颜色选择
- (IBAction)redColor:(id)sender {
    UIButton *btn = sender;
    [self alterColor:btn.backgroundColor];
}
- (IBAction)blueColor:(id)sender {
    UIButton *btn = sender;
    [self alterColor:btn.backgroundColor];
}
- (IBAction)noKnowColor:(id)sender {
    JJTrendsTextView *textView = self.trendsTextViews.lastObject;
    if (textView) {
        [textView removeFromSuperview];
        [self.trendsTextViews removeObject:textView];
    }
}

//添加文字框
- (IBAction)blackColor:(id)sender {

    JJTrendsTextView *trendsText = [[JJTrendsTextView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [trendsText upward];
    trendsText.clearRimBool = NO;
    trendsText.textColor = self.pdfAlterImageView.lineColor;

    trendsText.center = self.pdfAlterImageView.center;
    [_pdfAlterImageView addSubview:trendsText];
    [self.trendsTextViews addObject:trendsText];
    
}

//设置颜色
- (void) alterColor:(UIColor *) color
{
    self.pdfAlterImageView.lineColor = color;
}

//返回
- (IBAction)backVc:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//保存操作
- (IBAction)saveImage:(id)sender {
    //保存在沙盒的Documents目录
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    /*文件写入路径**/
//    NSString *filePath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%d.png",(int)[[NSDate date] timeIntervalSince1970]]];


    for (JJTrendsTextView *textView in self.trendsTextViews) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:textView.frame];
        label.text = textView.text;
        label.textColor = textView.textColor;
        label.font = textView.font;
        label.numberOfLines = 0;
        [_pdfAlterImageView addSubview:label];
        
        [textView removeFromSuperview];
    }
    
    UIImage *image = [JJGainImage gainImage:self.pdfAlterImageView];
    
    NSString *imageFilePath = [JJGainImage writeImage:image];

    NSArray *tabels = [self.coreData selectObject:@"PDFAlterRecordTabel" condition:[NSPredicate predicateWithFormat:@"pdfFilePath = %@ and pdfPage = %@",[JJGainImage fileNameWithFilePath:_filePath],[NSNumber numberWithInteger:_page]]];
    
    if (tabels.count > 0) {
        /*更新**/
        PDFAlterRecordTabel *pdfTabel = tabels.lastObject;
        pdfTabel.pdfFilePath = [JJGainImage fileNameWithFilePath:_filePath];
        pdfTabel.pdfImageFilePath = imageFilePath;
        pdfTabel.pdfPage = [NSNumber numberWithInteger:_page];
        
        [self.coreData save];
    } else {
        /*持久化存储**/
        PDFAlterRecordTabel *pdfTabel = [self.coreData insertNewObject:@"PDFAlterRecordTabel"];
        pdfTabel.pdfImageFilePath = imageFilePath;
        pdfTabel.pdfFilePath = [JJGainImage fileNameWithFilePath:_filePath];
        pdfTabel.pdfPage = [NSNumber numberWithInteger:_page];
        
        [self.coreData save];
    }

    [self dismissViewControllerAnimated:YES completion:^{
        //调用代理方法
        [self.dalegate alterViewControlleReloaddataImage:image];
    }];
}
//删除全部笔画
- (IBAction)deleteAllLine:(id)sender {
    [self.pdfAlterImageView allBack];
}
//删除一条笔画
- (IBAction)deleteLine:(id)sender {
    [self.pdfAlterImageView back];
}

- (MyCoreData *) coreData
{
    if (!_coreData) {
        _coreData = [[MyCoreData alloc] init];
    }
    return _coreData;
}

- (NSMutableArray *) trendsTextViews
{
    if (!_trendsTextViews) {
        _trendsTextViews = [[NSMutableArray alloc] init];
    }
    return _trendsTextViews;
}

@end
