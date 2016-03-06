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

typedef struct {
    CGPoint point1;
    CGPoint point2;
}AcrossPointStruct;

typedef enum {
    kQuadrant_First,
    kQuadrant_Second,
    kQuadrant_Third,
    kQuadrant_Fourth,
}kQuadrantArea;

@interface DropView : UIView

@property (strong, nonatomic) LineMath      *lineCenter2Center; //圆心的连线
@property (strong, nonatomic) CircleMath    *circleMath;        //圆的方程
@property (assign, nonatomic) CGPoint       edge_point1;        //圆心连线的垂线与圆的交点1
@property (assign, nonatomic) CGPoint       edge_point1_left;   //圆心连线的垂线与圆的交点1,贝塞尔绘制点左侧
@property (assign, nonatomic) CGPoint       edge_point1_right;  //圆心连线的垂线与圆的交点1,贝塞尔绘制点右侧
@property (assign, nonatomic) CGPoint       edge_point2;        //圆心连线的垂线与圆的交点2
@property (assign, nonatomic) CGPoint       edge_point2_left;   //圆心连线的垂线与圆的交点2,贝塞尔绘制点左侧
@property (assign, nonatomic) CGPoint       edge_point2_right;  //圆心连线的垂线与圆的交点2,贝塞尔绘制点右侧
@property (assign, nonatomic) CGPoint       bezierControlPoint1;//贝赛尔曲线控制点1（P3，P4中间）
@property (assign, nonatomic) CGPoint       bezierControlPoint2;//贝赛尔曲线控制点2（P1，P2中间）

@property (strong, nonatomic) DropView          *smallDrop;
@property (assign, nonatomic) DropCanvasView    *dropSuperView;
@property (assign, nonatomic) kQuadrantArea     smallDropQuadrant;

@property (strong, nonatomic) CAShapeLayer  *dropShapLayer;
@property (strong, nonatomic) UIBezierPath  *bezierPath;

- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop;

/** 判断点所处象限
 *
 *  centerPoint 作为圆心的点
 *  paraPoint   以centerPoint为坐标原点，判断paraPoint所在的象限
 *
 *  quadrantFirst   第一象限
 *  quadrantSecond  第二象限
 *  quadrantThird   第三象限
 *  quadrantFourth  第四象限
 */
+ (void)eventInDiffQuadrantWithCenterPoint:(CGPoint)centerPoint
                             withParaPoint:(CGPoint)paraPoint
                             quadrantFirst:(void (^)())quadrantFirst
                            quadrantSecond:(void (^)())quadrantSecond
                             quadrantThird:(void (^)())quadrantThird
                            quadrantFourth:(void (^)())quadrantFourth;

@end
