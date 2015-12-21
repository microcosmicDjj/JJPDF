//
//  TrendsTextView.h
//  TrendsTextView
//
//  Created by Mac on 15/10/9.
//  Copyright © 2015年 djj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJTrendsTextView : UITextView

@property (nonatomic) BOOL clearRimBool;

- (void) upward; //向上弹
- (void) down; //向下弹

@end
