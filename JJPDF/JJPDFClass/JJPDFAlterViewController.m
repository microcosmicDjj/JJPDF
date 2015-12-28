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
#import "JJPDFShowViewController.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "JJRedactImageViewController.h"

@interface JJPDFAlterViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,JJRedactImageDelegate>

@property (strong, nonatomic) JJPDFAlterImageView *pdfAlterImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) JJRedactImageViewController *redactImageVC;

@property (strong, nonatomic) MyCoreData *coreData;


@end

@implementation JJPDFAlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view.frame = rect;
    
    self.pdfAlterImageView.image = _image;
    self.pdfAlterImageView.frame = rect;

    [self.view insertSubview:self.pdfAlterImageView atIndex:0];
    
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
        _headLayoutConstraint.constant = -90;
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
//清除一个输入框
- (IBAction)noKnowColor:(id)sender {
    [self.pdfAlterImageView cleanTextView];
}

//添加文字框
- (IBAction)blackColor:(id)sender {
    [self.pdfAlterImageView addTextView];
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
    
    UIImage *image = [self.pdfAlterImageView saveImage];
    
    // 如果没有进行任何操作，就直接返回空，不调用代理方法
    if (!image) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        return;
    }
    
    //如果清空了数据，而没有进行任何操作将进入此方法
    __weak typeof(self) weakSelf = self;
    RIButtonItem *leftBtn = [RIButtonItem itemWithLabel:@"取消" action:^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
        
    RIButtonItem *rigthBtn = [RIButtonItem itemWithLabel:@"确认" action:^{
        [weakSelf saveData:image];
            
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [weakSelf.dalegate alterViewControlleReloaddataImage:image];
        }];
    }];
        
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认保存数据" message:nil cancelButtonItem:leftBtn otherButtonItems:rigthBtn, nil];
    [alertView show];
}

//保存操作
- (void) saveData:(UIImage *) image
{
    // 如果没有进行了操作，则保存至数据库
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
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        //调用代理方法
        [weakSelf.dalegate alterViewControlleReloaddataImage:image];
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

//清空笔记
- (IBAction)clearAllRecord:(id)sender {
    NSArray *tabels = [self.coreData selectObject:@"PDFAlterRecordTabel" condition:[NSPredicate predicateWithFormat:@"pdfFilePath = %@ and pdfPage = %@",[JJGainImage fileNameWithFilePath:_filePath],[NSNumber numberWithInteger:_page]]];
    if (tabels.count > 0){
        [self.coreData deleteObjects:tabels];
        
        JJPDFShowViewController *pdfShowVC = [[JJPDFShowViewController alloc] init];
        pdfShowVC.page = _page;
        pdfShowVC.pdfDocument = _pdfDocument;
        
        self.pdfAlterImageView.image = [JJGainImage gainImage:pdfShowVC.view];
        //清除了记录
        self.pdfAlterImageView.cleanRecord = YES;
    } else {
        
        
    }
    
}
//添加图片
- (IBAction)addImage:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    RIButtonItem *photoItem = [RIButtonItem itemWithLabel:@"相册中选取" action:^{
        [weakSelf setupImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    RIButtonItem *shootItem = [RIButtonItem itemWithLabel:@"拍照" action:^{
        [weakSelf setupImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消"];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancelItem destructiveButtonItem:nil otherButtonItems:shootItem,photoItem, nil];

    [sheet showInView:self.view];
}
//相机设置
- (void) setupImagePickerController:(UIImagePickerControllerSourceType) type
{
    UIImagePickerControllerSourceType sourceType = type;
    //如果没有相机的情况下，直接跳到图片选择的界面
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
    picker.allowsEditing=YES;
    
    picker.sourceType=sourceType;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

// UIImagePickerController 代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (image) {
            weakSelf.redactImageVC = nil;
            weakSelf.redactImageVC = [[JJRedactImageViewController alloc] init];
            weakSelf.redactImageVC.delegate = weakSelf;
            weakSelf.redactImageVC.image = image;
            [weakSelf presentViewController:weakSelf.redactImageVC animated:YES completion:^{
                
            }];
        }
    }];
}

/*
 * MARK : 图片处理回调方法
 */
- (void) redactImage:(UIImage *) image imageFrame:(CGRect)frame
{
    [self.pdfAlterImageView addImageView:image imageFrame:frame];
}

//删除一张图片
- (IBAction)delImage:(id)sender {
    [self.pdfAlterImageView cleanImageView];
}

- (MyCoreData *) coreData
{
    if (!_coreData) {
        _coreData = [[MyCoreData alloc] init];
    }
    return _coreData;
}

- (JJPDFAlterImageView *) pdfAlterImageView
{
    if (!_pdfAlterImageView) {
        _pdfAlterImageView = [[JJPDFAlterImageView alloc] init];
    }
    
    return _pdfAlterImageView;
}

@end
