//
//  DropView.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropView.h"
#import "LineMath.h"

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
    _center_point = CGPointMake(self.width/2, self.height/2);
    
    
    //SmallDrop
    
    
    [self updateAssistantCanvas];
}

- (void)updateAssistantCanvas
{
    [_dropSuperView.lineArray removeAllObjects];
    
    _center_point = CGPointMake(self.width/2, self.height/2);
    CALayer *smallDrop_layer = _smallDrop.layer.presentationLayer;
    LineMath *lineCenter2Center = [[LineMath alloc] initWithPoint1:_center_point point2:smallDrop_layer.position inView:self];
    [_dropSuperView.lineArray addObject:lineCenter2Center];
    
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





