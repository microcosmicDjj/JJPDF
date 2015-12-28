
//
//  JJPDFAlterImageView.m
//  JJPDF
//
//  Created by Mac on 15/12/17.
//  Copyright © 2015年 DJJ. All rights reserved.
//

#import "JJPDFAlterImageView.h"
#import "JJPDFAlterModel.h"
#import "JJTrendsTextView.h"
#import "JJGainImage.h"
#import "JJTrendsImageView.h"
#import "JJPDFViewConstant.h"
#import "UIView+JJMoveView.h"
#import "UIView+JJExpansion.h"

@interface JJPDFAlterImageView ()

@property (nonatomic, strong) NSMutableArray *alterModels;
@property (nonatomic, strong) NSMutableArray *trendsTextViews;
@property (nonatomic, strong) NSMutableArray *trendsImageViews;

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
    //初始值设置为假
    _cleanRecord = NO;
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

//清除一条线
- (void) back
{
    [self removeLastObject];
    [self setNeedsDisplay];
}

//清除全部线
- (void) allBack
{
    [self.alterModels removeAllObjects];
    [self setNeedsDisplay];
}

//添加输入框
- (void) addTextView
{
    JJTrendsTextView *trendsText = [[JJTrendsTextView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [trendsText upward];
    trendsText.clearRimBool = NO;
    trendsText.textColor = self.lineColor;
    
    trendsText.center = self.center;
    [self addSubview:trendsText];
    [self.trendsTextViews addObject:trendsText];
}

/*清除一个输入框**/
- (void) cleanTextView
{
    JJTrendsTextView *textView = self.trendsTextViews.lastObject;
    
    if (textView) {
        [textView removeFromSuperview];
        [self.trendsTextViews removeObject:textView];
    }
}
/*清除所有的输入框**/
- (void) cleanAllTextView
{
    for (JJTrendsTextView *textView in self.trendsTextViews) {
        [textView removeFromSuperview];
    }
    [self.trendsTextViews removeAllObjects];
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

//清除一张图片
- (void) cleanImageView
{
    JJTrendsImageView *imageView = self.trendsImageViews.lastObject;
    
    if (imageView) {
        [imageView removeFromSuperview];
        [self.trendsImageViews removeObject:imageView];
    }
}

//清除所有图片
- (void) cleanAllImageView
{
    for (JJTrendsImageView *imageView in self.trendsImageViews) {
        [imageView removeFromSuperview];
    }
    [self.trendsImageViews removeAllObjects];

}
/*保存图片**/
- (UIImage *) saveImage
{
    NSLog(@"self.alterModels.count = %ld",self.alterModels.count);
    //如果没有任何操作直接返回nil
    if (self.trendsTextViews.count == 0 && self.alterModels.count == 0) {
        return nil;
    }

    for (JJTrendsTextView *textView in self.trendsTextViews) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:textView.frame];
        label.text = textView.text;
        label.textColor = textView.textColor;
        label.font = textView.font;
        label.numberOfLines = 0;
        [self addSubview:label];
        
        [textView removeFromSuperview];
    }

    return [JJGainImage gainImage:self];
}

/*
 * MARK: 添加图片
 */

- (void) addImageView:(UIImage *) image imageFrame:(CGRect) frame
{
    JJTrendsImageView *imageView = [[JJTrendsImageView alloc] init];
    imageView.image = image;
    imageView.frame = frame;
    imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self addSubview:imageView];
    
    [imageView openMove:^(CGPoint point) {
        
    }];
//    __weak typeof(self) weakSelf = self;
    [imageView openExpansionGesticulationBlock:^(CGPoint point) {
//        NSLog(@"weakSelf.moveImageView.image.size = %@",NSStringFromCGSize(imageView.image.size));
    }];
    
    [self.trendsImageViews addObject:imageView];
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

- (NSMutableArray *) trendsTextViews
{
    if (!_trendsTextViews) {
        _trendsTextViews = [[NSMutableArray alloc] init];
    }
    
    return _trendsTextViews;
}

- (NSMutableArray *) trendsImageViews
{
    if (!_trendsImageViews) {
        _trendsImageViews = [[NSMutableArray alloc] init];
    }
    return _trendsImageViews;
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    
    self.backgroundColor = [UIColor colorWithPatternImage:_image];
}

@end
