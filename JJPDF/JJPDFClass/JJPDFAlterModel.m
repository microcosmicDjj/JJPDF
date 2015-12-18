//
//  JJPDFAlterModel.m
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJPDFAlterModel.h"

@implementation JJPDFAlterModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lineColor = [UIColor blackColor];//默认为黑色
        _lineWidth = 3; //默认为5
    }
    return self;
}

- (NSMutableArray *) linePoints
{
    if (!_linePoints) {
        _linePoints = [[NSMutableArray alloc] init];
    }
    return _linePoints;
}

@end
