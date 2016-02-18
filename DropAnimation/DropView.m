//
//  DropView.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropView.h"

@interface DropView()
@property (strong, nonatomic) DropView      *smallDrop;

@end

@implementation DropView

- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    [self createDropShapeLayer];
    [self createCenterPointView];
    
    if (createSmallDrop == YES) {
        [self createSmallDrop];
        [self createPanGesture];
    }
    
    return self;
}

- (void)createCenterPointView
{
    _centerPointView = [[PointView alloc] initWithPoint:CGPointMake(self.width/2, self.height/2)];
    [self addSubview:_centerPointView];
}

- (void)createDropShapeLayer
{
    _dropShapLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_dropShapLayer];
    
    _bezierPath = [UIBezierPath bezierPath];
    [_bezierPath addArcWithCenter:CGPointMake(self.centerX, self.centerY) radius:self.width/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _dropShapLayer.path = _bezierPath.CGPath;
}

- (void)createSmallDrop
{
    CGFloat smallDrop_width = 50;
    _smallDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, smallDrop_width, smallDrop_width) createSmallDrop:NO];
    _smallDrop.dropShapLayer.fillColor = [UIColor redColor].CGColor;
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
    }
    else if(panGesture.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:0.3
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [_smallDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
}

@end
