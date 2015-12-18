//
//  ViewController.m
//  JJPDF
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "ViewController.h"
#import "JJPDFMainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)readPdf:(id)sender {
    JJPDFMainViewController *mainVC = [[JJPDFMainViewController alloc] init];
    mainVC.filePath = [[NSBundle mainBundle] pathForResource:@"6666" ofType:@"pdf"];
    [self presentViewController:mainVC animated:YES completion:^{
        
    }];
}



@end
