//
//  JJPDFShowViewController.m
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJPDFShowViewController.h"

@interface JJPDFShowViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JJPDFShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view.frame = rect;
    
    self.imageView.bounds = rect;
    
    if (_image) {
        self.imageView.image = _image;
        self.pdfView.hidden = YES;
        self.imageView.hidden = NO;
    } else {
        self.pdfView.pdfDocument = _pdfDocument;
        self.pdfView.page = _page;
        
        self.pdfView.hidden = NO;
        self.imageView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
