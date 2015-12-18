
//
//  JJPDFAlterImageView.m
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJPDFAlterImageView.h"
#import "JJPDFAlterModel.h"

@interface JJPDFAlterImageView ()

@property (nonatomic, strong) NSMutableArray *alterModels;

@end

@implementation JJPDFAlterImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}
/*
 * MARK:一般的设置
 */
- (void) setupView
{
    self.userInteractionEnabled = YES;
    CGRect rect = [UIScreen mainScreen].bounds;
    self.bounds = rect;
}

/*
 * MARK: 手势
 */
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    JJPDFAlterModel *alterModel = [[JJPDFAlterModel alloc] init];
    if (_lineColor != nil) {
        alterModel.lineColor = _lineColor;
    }
    if (_lineWidth != 0) {
        alterModel.lineWidth = _lineWidth;
    }
    
    [self.alterModels addObject:alterModel];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //取到最后一个
    JJPDFAlterModel *alterModel = self.alterModels.lastObject;
    //转成对象
    NSValue *value = [NSValue valueWithCGPoint:point];
    //添加进数组
    [alterModel.linePoints addObject:value];
    
        //渲染
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //使其变得圆滑
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    //遍历所以的点然后渲染
    for (JJPDFAlterModel *model in self.alterModels) {
        if (model.linePoints.count > 5) {
            for (int i = 0; i < model.linePoints.count; i++) {
                NSValue *value = model.linePoints[i];
                CGPoint point = [value CGPointValue];
                if (i == 0) {
                    CGContextMoveToPoint(context, point.x, point.y);
                } else {
                    CGContextAddLineToPoint(context, point.x, point.y);
                }
            }
        }
        [model.lineColor set];
        CGContextSetLineWidth(context, model.lineWidth);
        
        CGContextStrokePath(context);
    }
}

- (void) back
{
    [self removeLastObject];
    [self setNeedsDisplay];
}

- (void) allBack
{
    [self.alterModels removeAllObjects];
    [self setNeedsDisplay];
}

/**
 * MARK: 清楚第一条线和多余的线
 */
- (void) removeLastObject
{
    JJPDFAlterModel *model = (JJPDFAlterModel *)self.alterModels.lastObject;
    //如果是空直接返回，防崩
    if (!model) {
        return;
    }
    if (model.linePoints.count < 6) {
        [self.alterModels removeObject:model];
        [self removeLastObject];
    } else {
        [self.alterModels removeObject:model];
    }
}

/*
 * MARK: 懒加载
 */
- (NSMutableArray *) alterModels
{
    if (!_alterModels) {
        _alterModels = [[NSMutableArray alloc] init];
    }
    return _alterModels;
}


- (void) setImage:(UIImage *)image
{
    _image = image;
    
    self.backgroundColor = [UIColor colorWithPatternImage:_image];
}

@end
