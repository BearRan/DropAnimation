//
//  DropView.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropView.h"

@interface DropView()

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) PointView     *centerPointView;

@end



@implementation DropView

- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
//    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.width/2;
    self.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
    [self createDropView];
    [self createCenterPointView];
    
    if (createSmallDrop == YES) {
        [self createSmallDropView];
        [self createPanGesture];
    }
    
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    
    return self;
}

- (void)createDropView
{
    _circleMath = [[CircleMath alloc] initWithCenterPoint:CGPointMake(self.width/2, self.height/2) radius:self.width/2 inView:self];
    
    _bezierPath = [UIBezierPath bezierPath];
    
    _dropShapLayer = [CAShapeLayer layer];
    _dropShapLayer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.4].CGColor;
    _dropShapLayer.lineWidth = 5.0f;
    _dropShapLayer.strokeColor = [UIColor blackColor].CGColor;
    _dropShapLayer.strokeStart = 0;
    _dropShapLayer.strokeEnd = 1;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calucateCoordinate)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink.paused = YES;
}

- (void)createCenterPointView
{
    _centerPointView = [[PointView alloc] initWithPoint:CGPointMake(self.width/2, self.height/2)];
    [self addSubview:_centerPointView];
}

- (void)createSmallDropView
{
    CGFloat smallDrop_width = 80;
    _smallDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, smallDrop_width, smallDrop_width) createSmallDrop:NO];
    _smallDrop.layer.cornerRadius = smallDrop_width/2;
    _smallDrop.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [self addSubview:_smallDrop];
    [_smallDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)createPanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture_Event:)];
    [self addGestureRecognizer:panGesture];
}

- (void)panGesture_Event:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint tempPoint = [panGesture locationInView:self];
        _smallDrop.center = tempPoint;
        [self calucateCoordinate];
    }
    else if(panGesture.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:0.3
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [_smallDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
                             _displayLink.paused = NO;
                         }
                         completion:^(BOOL finished) {
                             _displayLink.paused = YES;
                         }];
    }
}

- (void)calucateCoordinate
{
    [_dropSuperView.lineArray removeAllObjects];
    
    //  两点间的连线
    CALayer *smallDrop_layer = _smallDrop.layer.presentationLayer;
    _lineCenter2Center = [[LineMath alloc] initWithPoint1:_circleMath.centerPoint point2:smallDrop_layer.position inView:self];
//    [_dropSuperView.lineArray addObject:_lineCenter2Center];
    
    
    CGPoint mainDrop_center = CGPointMake(self.width/2, self.height/2);
    CGPoint smallDrop_center = smallDrop_layer.position;
    //  第一象限
    if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y > smallDrop_center.y) {
        _smallDropQuadrant = kQuadrant_First;
    }
    //  第二象限
    else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y > smallDrop_center.y){
        _smallDropQuadrant = kQuadrant_Second;
    }
    //  第三象限
    else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
        _smallDropQuadrant = kQuadrant_Third;
    }
    //  第四象限
    else if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
        _smallDropQuadrant = kQuadrant_Fourth;
    }
    
    
    CGFloat centerPointDistance = [LineMath calucateDistanceBetweenPoint1:_circleMath.centerPoint withPoint2:smallDrop_layer.position];
    
    //  两圆无重叠
    if (centerPointDistance > _circleMath.radius + _smallDrop.circleMath.radius) {
        
        //  bigDrop与lineCenter2Center的垂直平分线的交点
        [self calucateCircleAndPerBiseLinePoint_withCircle:self.circleMath withDropView:self];
        
        //  smallDrop与lineCenter2Center的垂直平分线的交点
        [self calucateCircleAndPerBiseLinePoint_withCircle:self.smallDrop.circleMath withDropView:self.smallDrop];
    }
    //  两圆有重叠
    else{
        NSLog(@"两圆有重叠");
        [self calucateCircleWithCircleAcrossPoint];
    }
    
    [_dropSuperView setNeedsDisplay];
}


//  计算Center2Center过圆心的垂直平分线和DropView的交点
- (void)calucateCircleAndPerBiseLinePoint_withCircle:(CircleMath *)circle withDropView:(DropView *)dropView
{
    CGPoint tempCenter = [self convertPoint:circle.centerPoint fromView:circle.InView];
    CGFloat x0 = tempCenter.x;
    CGFloat y0 = tempCenter.y;
    
    //  Center2Center的的垂直平分线 perpendicularBisector
    LineMath *perBiseLine = [[LineMath alloc] init];
    CGFloat angle = atan(_lineCenter2Center.k);
    angle += M_PI/2;
    if (angle > M_PI/2) {
        angle -= M_PI;
    }else if (angle < - M_PI/2){
        angle += M_PI;
    }
    perBiseLine.k = tan(angle);
    perBiseLine.b = y0 - perBiseLine.k * x0;
    
    AcrossPointStruct acrossPointStruct = [self calucateCircleAndLineAcrossPoint_withCircle:circle withLine:perBiseLine];
    dropView.edge_point1 = acrossPointStruct.point1;
    dropView.edge_point2 = acrossPointStruct.point2;
}


/** 已知过圆心的直线方程，求圆与直线的两个交点
 *
 *  1，圆的方程
 *  dx方 = (x2 - x1)方 + (y2 - y1)方
 *  2，直线方程
 *  y = kx + b
 *
 *  联立1，2方程式，得出二次函数
 *  ax方 + bx + c = 0
 *  其中：
 *  a = ((kLine * kLine) + 1)
 *  b = - ((2 * x0) - (2 * kLine * bLine) + (2 * kLine * y0))
 *  c = (x0 * x0) + (bLine * bLine) - (2 * bLine * y0) + (y0 * y0) - (dx * dx)
 *  delta = b方 - 4ac
 *  解出该二次函数的两个根，就能得出圆与直线的两个交点的x值，从而得出圆与直线的两个交点的坐标
 *
 *  参数说明
 *  (x0, y0)    圆心坐标
 *  kLine       直线的斜率
 *  bLine       直线的b参数
 *  dx          圆的半径
 *  a,b,c,delta 上面都已说明，不再解释
 */
- (AcrossPointStruct)calucateCircleAndLineAcrossPoint_withCircle:(CircleMath *)circle withLine:(LineMath *)line
{
    CGPoint tempCenter = [self convertPoint:circle.centerPoint fromView:circle.InView];
    CGFloat x0 = tempCenter.x;
    CGFloat y0 = tempCenter.y;

    CGFloat kLine = line.k;
    CGFloat bLine = line.b;
    
    CGFloat dx = circle.radius;
    CGFloat a = ((kLine * kLine) + 1);
    CGFloat b = - ((2 * x0) - (2 * kLine * bLine) + (2 * kLine * y0));
    CGFloat c = (x0 * x0) + (bLine * bLine) - (2 * bLine * y0) + (y0 * y0) - (dx * dx);
    AcrossPointStruct acrossPointStruct;
    
    float delta = (b * b) - (4 * a * c);
    if (delta > 0) {
        //        NSLog(@"两个根");
        
        CGFloat x1_result = ((-b) - sqrt(delta)) / (2 * a);
        CGFloat y1_result = (kLine * x1_result) + bLine;
        
        CGFloat x2_result = ((-b) + sqrt(delta)) / (2 * a);
        CGFloat y2_result = (kLine * x2_result) + bLine;
        
        acrossPointStruct.point1 = CGPointMake(x1_result, y1_result);
        acrossPointStruct.point2 = CGPointMake(x2_result, y2_result);
        
        //  edgePoint矫正
        switch (_smallDropQuadrant) {
                //  第一象限
            case kQuadrant_First:
                acrossPointStruct.point1 = CGPointMake(x2_result, y2_result);
                acrossPointStruct.point2 = CGPointMake(x1_result, y1_result);
                break;
                
                //  第二象限
            case kQuadrant_Second:
                acrossPointStruct.point1 = CGPointMake(x2_result, y2_result);
                acrossPointStruct.point2 = CGPointMake(x1_result, y1_result);
                break;
                
                //  第三象限
            case kQuadrant_Third:
                
                break;
                
                //  第四象限
            case kQuadrant_Fourth:
                
                break;
                
            default:
                break;
        }
        
        LineMath *perBiseLine_BigDrop_result = [[LineMath alloc] initWithPoint1:acrossPointStruct.point1 point2:acrossPointStruct.point2 inView:self];
        [_dropSuperView.lineArray addObject:perBiseLine_BigDrop_result];
        
    }else if (delta == 0){
        NSLog(@"圆与直线 一个交点");
    }else{
        NSLog(@"圆与直线 无交点");
    }
    
    return acrossPointStruct;
}


/** 计算两圆有重叠时的交点
 *
 *  r1  小圆半径
 *  r2  大圆半径
 *  x   两圆心的距离
 *  x1  小圆圆心和两圆焦点连线的距离
 *  x2  大圆圆心和两圆焦点连线的距离
 *  x3  两圆连线的线长的一半长度
 *
 *  (x_o,y_o)   两圆圆心连线和两圆焦点连线的交点
 *  verLine     两圆心连线基于点(x_o,y_o)的垂线
 */
- (void)calucateCircleWithCircleAcrossPoint
{
    CGFloat r1 = _smallDrop.circleMath.radius;
    CGFloat r2 = _circleMath.radius;
    CALayer *smallDrop_layer = _smallDrop.layer.presentationLayer;
    CGFloat x  = [LineMath calucateDistanceBetweenPoint1:_circleMath.centerPoint withPoint2:smallDrop_layer.position];
    CGFloat x1;
    CGFloat x2;
    CGFloat x3;
    CGFloat x_o;
    CGFloat y_o;
    
    x1 = ( (r1*r1) - (r2*r2) + (x*x)) / (2 * x);
    x2 = x - x1;
    x3 = sqrt((r1*r1) - (x1*x1));
    
    CGFloat angle = atan(_lineCenter2Center.k);
    //  edgePoint矫正
    switch (_smallDropQuadrant) {
            //  第一象限
        case kQuadrant_First:
            x_o = self.width/2 + cos(angle) * x2;
            break;
            
            //  第二象限
        case kQuadrant_Second:
            x_o = self.width/2 - cos(angle) * x2;
            break;
            
            //  第三象限
        case kQuadrant_Third:
            x_o = self.width/2 - cos(angle) * x2;
            break;
            
            //  第四象限
        case kQuadrant_Fourth:
            x_o = self.width/2 + cos(angle) * x2;
            break;
            
        default:
            break;
    }
    
    y_o = _lineCenter2Center.k * x_o + _lineCenter2Center.b;

    LineMath *tempLine = [[LineMath alloc] initWithPoint1:CGPointMake(self.width/2, self.height/2) point2:CGPointMake(x_o, y_o) inView:self];
    [_dropSuperView.lineArray addObject:tempLine];
    
    //  Center2Centerde的垂线 VerticalLine
    LineMath *verLine = [[LineMath alloc] init];
    angle += M_PI/2;
    if (angle > M_PI/2) {
        angle -= M_PI;
    }else if (angle < - M_PI/2){
        angle += M_PI;
    }
    verLine.k = tan(angle);
    verLine.b = y_o - verLine.k * x_o;
    
    AcrossPointStruct acrossPointStruct = [self calucateCircleAndLineAcrossPoint_withCircle:_circleMath withLine:verLine];
    verLine.point1 = acrossPointStruct.point1;
    verLine.point2 = acrossPointStruct.point2;
    
    _edge_point1 = verLine.point1;
    _edge_point2 = verLine.point2;
    
    _smallDrop.edge_point1 = verLine.point1;
    _smallDrop.edge_point2 = verLine.point2;
    
    [_dropSuperView.lineArray addObject:verLine];
}

@end





