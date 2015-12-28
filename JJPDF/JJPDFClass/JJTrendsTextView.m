//
//  TrendsTextView.m
//  TrendsTextView
//
//  Created by Mac on 15/10/9.
//  Copyright © 2015年 djj. All rights reserved.
//

#import "JJTrendsTextView.h"
#import "UIView+LayoutMethods.h"
#import "UIView+JJMoveView.h"

@interface JJTrendsTextView () 

@property (nonatomic) BOOL isUpward;
@property (nonatomic) BOOL isDown;
/*记录self的宽度**/
@property (nonatomic) CGFloat selfW;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rigthView;

@end

@implementation JJTrendsTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isDown = YES; // 默认向下
        _isUpward = NO;
        //设置边框
        
        self.backgroundColor = [UIColor clearColor];
        
        //键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelfSizeWithStringSize) name:UITextViewTextDidChangeNotification object:self];

        //可以自由拉动
        [self setMovePanGestureRecognizer];
        
        [self openMove:^(CGPoint point) {
            
        }];
    }
    return self;
}

//MARK : 可以自由拉动
- (void) setMovePanGestureRecognizer
{
    
    self.leftView.tag =  1;
    [self addSubview:self.leftView];
    
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveLeftRightView:)];
    [self.leftView addGestureRecognizer:leftPan];

    self.rigthView.tag =  2;
    [self addSubview:self.rigthView];
    
    UIPanGestureRecognizer *rigthPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveLeftRightView:)];
    [self.rigthView addGestureRecognizer:rigthPan];
    
    _selfW = self.width;
}


- (void) moveLeftRightView:(UIPanGestureRecognizer *) tap
{
    CGPoint translation = [tap translationInView:self];
    tap.view.centerX = tap.view.center.x + translation.x;
    
    if (tap.view.tag == 1) {
        float selfX = self.width + self.x;
        self.width = _selfW - translation.x;
        self.x = selfX - self.width;
    } else {
        self.width = _selfW + translation.x;
    }
    if (self.width < 60) {
        self.width = 60;
    }

    [self astrict];
    [self changeSelfSizeWithStringSize]; 
    
    if (tap.state == UIGestureRecognizerStateEnded){
        _selfW = self.width;
    }
}

//MARK : 接受通知
- (void) changeSelfSizeWithStringSize
{
    CGSize size = self.contentSize;
 
    size.height = size.height + 5;
    if (_isDown) {
        self.frame = CGRectMake(self.x, self.y,self.width,size.height);
    }
    if (_isUpward) {
        CGFloat y = (self.y + self.height) - size.height;
        self.frame = CGRectMake(self.x, y, self.width, size.height);
    }
    self.leftView.frame = CGRectMake(0, 0, 20, self.height);
    self.rigthView.frame = CGRectMake(self.width - 20, 0, 20, self.height);

}

- (void) upward
{
    _isDown = NO;
    _isUpward = YES;
}

-(void) down
{
    _isDown = YES;
    _isUpward = NO;
}

- (void) setClearRimBool:(BOOL)clearRimBool
{
    _clearRimBool = clearRimBool;
    if (_clearRimBool) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

- (UIView *) leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, self.height)];
    }
    return _leftView;
}

- (UIView *) rigthView
{
    if (!_rigthView) {
        _rigthView = [[UIView alloc] initWithFrame:CGRectMake(self.width - 20, 0, 20, self.height)];
    }
    return _rigthView;
}

@end
