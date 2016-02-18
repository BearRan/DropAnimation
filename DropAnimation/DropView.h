//
//  DropView.h
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointView.h"
#import "DropCanvasView.h"

@interface DropView : UIView

@property (strong, nonatomic) UIColor   *fillColor;
@property (assign, nonatomic) CGPoint   center_point;
@property (assign, nonatomic) CGPoint   edge_point1;
@property (assign, nonatomic) CGPoint   edge_point2;

@property (assign, nonatomic) DropCanvasView *dropSuperView;

- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop;

@end
