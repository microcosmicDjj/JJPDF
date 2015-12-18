//
//  JJPDFView.m
//  JJPDF
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJPDFView.h"
//#import "JJPDFViewConstant.h"

@interface JJPDFView ()


@end

@implementation JJPDFView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) setPage:(NSInteger)page
{
    _page = page;
    [self setNeedsDisplay];
}

- (void) setPdfDocument:(CGPDFDocumentRef)pdfDocument
{
    _pdfDocument = pdfDocument;
    [self setNeedsDisplay];
}

/*
 * MAEK:渲染pdf
 */
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (_page == 0) {
        _page = 1;
    }
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(_pdfDocument, _page);
    CGContextSaveGState(context);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(pageRef, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    CGContextDrawPDFPage(context, pageRef);
    CGContextRestoreGState(context);
}

@end
