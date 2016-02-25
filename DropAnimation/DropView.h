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
#import "CircleMath.h"
#import "LineMath.h"

@interface DropView : UIView

@property (strong, nonatomic) UIColor       *fillColor;
@property (strong, nonatomic) LineMath      *lineCenter2Center; //圆心的连线
@property (strong, nonatomic) CircleMath    *circleMath;        //圆的方程
@property (assign, nonatomic) CGPoint       edge_point1;        //圆心连线的垂线与圆的交点1
@property (assign, nonatomic) CGPoint       edge_point2;        //圆心连线的垂线与圆的交点2

@property (strong, nonatomic) DropView          *smallDrop;
@property (assign, nonatomic) DropCanvasView    *dropSuperView;

@property (strong, nonatomic) CAShapeLayer  *dropShapLayer;
@property (strong, nonatomic) UIBezierPath  *bezierPath;

- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop;

@end
