//
//  DropView.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropView.h"
#import "LineMath.h"
#import "CircleMath.h"

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
    _dropShapLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_dropShapLayer];
    
    _bezierPath = [UIBezierPath bezierPath];
//    [_bezierPath addArcWithCenter:CGPointMake(self.centerX, self.centerY) radius:self.width/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _dropShapLayer.path = _bezierPath.CGPath;
    
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
    CGFloat smallDrop_width = 50;
    _smallDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, smallDrop_width, smallDrop_width) createSmallDrop:NO];
    _smallDrop.fillColor = [UIColor redColor];
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
    //BigDrop
    
    
    //SmallDrop
    
    
    [self updateAssistantCanvas];
}

- (void)updateAssistantCanvas
{
    [_dropSuperView.lineArray removeAllObjects];
    
    _center_point = CGPointMake(self.width/2, self.height/2);
    CALayer *smallDrop_layer = _smallDrop.layer.presentationLayer;
    
    //  两点间的连线
    LineMath *lineCenter2Center = [[LineMath alloc] initWithPoint1:_center_point point2:smallDrop_layer.position inView:self];
    [_dropSuperView.lineArray addObject:lineCenter2Center];
    
    //  BigDrop垂直平分线 perpendicularBisector
    LineMath *perBiseLine_BigDrop = [[LineMath alloc] init];
    CGFloat angle = atan(lineCenter2Center.k);
    angle += M_PI/2;
    
    if (angle > M_PI/2) {
        angle -= M_PI;
    }else if (angle < - M_PI/2){
        angle += M_PI;
    }
    
    perBiseLine_BigDrop.k = tan(angle);
    perBiseLine_BigDrop.b = _center_point.y - perBiseLine_BigDrop.k * _center_point.x;
    
    //  绘制零时的垂直平分线
//    CGFloat x1_temp = -100;
//    CGFloat y1_temp = perBiseLine_BigDrop.k * x1_temp + perBiseLine_BigDrop.b;
//    
//    CGFloat x2_temp = 100;
//    CGFloat y2_temp = perBiseLine_BigDrop.k * x2_temp + perBiseLine_BigDrop.b;
//    
//    CGPoint point1_temp = CGPointMake(x1_temp, y1_temp);
//    CGPoint point2_temp = CGPointMake(x2_temp, y2_temp);
//    
//    LineMath *perBiseLine_BigDrop_result = [[LineMath alloc] initWithPoint1:point1_temp point2:point2_temp inView:self];
//    [_dropSuperView.lineArray addObject:perBiseLine_BigDrop_result];
    
    
    
    
    
    //  已知直线方程，圆心，圆半径，求交点
    //  即 已知直线方程，某一点，距离，求交点
    //  dx方 = (x2 - x1)方 + (y2 - y1)方
    //  二次函数 y = ax方 + bx + c
    //  直线方程 y = kx + b
    //  圆心  (x0, y0)
    //  delta = b方 - 4ac
    
    CGFloat x0 = _center_point.x;
    CGFloat y0 = _center_point.y;
    CGFloat kLine = perBiseLine_BigDrop.k;
    CGFloat bLine = perBiseLine_BigDrop.b;
    
    CGFloat dx = self.width/2.0f;
    CGFloat a = ((kLine * kLine) + 1);
    CGFloat b = - ((2 * x0) - (2 * kLine * bLine) + (2 * kLine * y0));
    CGFloat c = (x0 * x0) + (bLine * bLine) - (2 * bLine * y0) + (y0 * y0) - (dx * dx);
    
    float delta = (b * b) - (4 * a * c);
    if (delta > 0) {
        NSLog(@"两个根");
        
        CGFloat x1_result = ((-b) - sqrt(delta)) / (2 * a);
        CGFloat y1_result = (kLine * x1_result) + bLine;
        
        CGFloat x2_result = ((-b) + sqrt(delta)) / (2 * a);
        CGFloat y2_result = (kLine * x2_result) + bLine;
        
        _edge_point1 = CGPointMake(x1_result, y1_result);
        _edge_point2 = CGPointMake(x2_result, y2_result);
        
        LineMath *perBiseLine_BigDrop_result = [[LineMath alloc] initWithPoint1:_edge_point1 point2:_edge_point2 inView:self];
        [_dropSuperView.lineArray addObject:perBiseLine_BigDrop_result];
    }else if (delta == 0){
        NSLog(@"一个根");
    }else{
        NSLog(@"无解");
    }
    
    
    
    
    
//    CircleMath *BigCircleMath = [[CircleMath alloc] initWithCenterPoint:_center_point radius:self.width/2 inView:self];
    
    //  SmallDrop垂直平分线
//    CircleMath *SmallCircleMath = [[CircleMath alloc] initWithCenterPoint:smallDrop_layer.position radius:_smallDrop.width/2 inView:self];
    
    
    [_dropSuperView setNeedsDisplay];
}


@synthesize fillColor = _fillColor;
- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    _dropShapLayer.fillColor = fillColor.CGColor;
//    self.alpha = 0.5;
}

@end





