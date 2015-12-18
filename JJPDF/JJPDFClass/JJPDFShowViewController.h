//
//  JJPDFShowViewController.h
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJPDFView.h"

@interface JJPDFShowViewController : UIViewController

@property (weak, nonatomic) IBOutlet JJPDFView *pdfView;

@property (strong, nonatomic) UIImage *image;
@property (nonatomic) NSInteger page;
@property (nonatomic) CGPDFDocumentRef pdfDocument;

@end
