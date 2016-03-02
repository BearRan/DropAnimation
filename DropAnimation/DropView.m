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
    
    self.backgroundColor = [UIColor clearColor];
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
    _smallDrop.dropShapLayer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
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
    [_dropSuperView.lineArray addObject:_lineCenter2Center];
    
    
    //  bigDrop与lineCenter2Center的垂直平分线的交点
    [self calucateCircleAndPerBiseLinePoint_withCircle:self.circleMath withDropView:self];
    
    //  smallDrop与lineCenter2Center的垂直平分线的交点
    [self calucateCircleAndPerBiseLinePoint_withCircle:self.smallDrop.circleMath withDropView:self.smallDrop];
    
    
    [_dropSuperView setNeedsDisplay];
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
- (void)calucateCircleAndPerBiseLinePoint_withCircle:(CircleMath *)circle withDropView:(DropView *)dropView
{
    CGPoint tempCenter = [self convertPoint:circle.centerPoint fromView:circle.InView];
    CALayer *smallDrop_layer = _smallDrop.layer.presentationLayer;
    CGFloat x0 = tempCenter.x;
    CGFloat y0 = tempCenter.y;
    
    
    //  Center2Centerde的垂直平分线 perpendicularBisector
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
    
    
    CGFloat kLine = perBiseLine.k;
    CGFloat bLine = perBiseLine.b;
    
    CGFloat dx = circle.radius;
    CGFloat a = ((kLine * kLine) + 1);
    CGFloat b = - ((2 * x0) - (2 * kLine * bLine) + (2 * kLine * y0));
    CGFloat c = (x0 * x0) + (bLine * bLine) - (2 * bLine * y0) + (y0 * y0) - (dx * dx);
    
    float delta = (b * b) - (4 * a * c);
    if (delta > 0) {
//        NSLog(@"两个根");
        
        CGFloat x1_result = ((-b) - sqrt(delta)) / (2 * a);
        CGFloat y1_result = (kLine * x1_result) + bLine;
        
        CGFloat x2_result = ((-b) + sqrt(delta)) / (2 * a);
        CGFloat y2_result = (kLine * x2_result) + bLine;
        
        dropView.edge_point1 = CGPointMake(x1_result, y1_result);
        dropView.edge_point2 = CGPointMake(x2_result, y2_result);
        
        CGPoint mainDrop_center = CGPointMake(self.width/2, self.height/2);
        CGPoint smallDrop_center = smallDrop_layer.position;
        //  edgePoint矫正
        //  第一象限
        if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y > smallDrop_center.y) {
                dropView.edge_point1 = CGPointMake(x2_result, y2_result);
                dropView.edge_point2 = CGPointMake(x1_result, y1_result);
        }
        //  第二象限
        else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y > smallDrop_center.y){
                dropView.edge_point1 = CGPointMake(x2_result, y2_result);
                dropView.edge_point2 = CGPointMake(x1_result, y1_result);
        }
        //  第三象限
        else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
            
        }
        //  第四象限
        else if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
            
        }
        
        LineMath *perBiseLine_BigDrop_result = [[LineMath alloc] initWithPoint1:dropView.edge_point1 point2:dropView.edge_point2 inView:self];
        [_dropSuperView.lineArray addObject:perBiseLine_BigDrop_result];
        
    }else if (delta == 0){
//        NSLog(@"一个根");
    }else{
//        NSLog(@"无解");
    }
}

@end





