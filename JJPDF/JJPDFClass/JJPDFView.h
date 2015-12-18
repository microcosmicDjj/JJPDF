//
//  JJPDFView.h
//  JJPDF
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJPDFView : UIView

@property (nonatomic) NSInteger page;
@property (nonatomic) CGPDFDocumentRef pdfDocument;

@end
