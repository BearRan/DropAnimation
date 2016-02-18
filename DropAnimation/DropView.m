//
//  DropView.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropView.h"
#import "AssistantCanvasView.h"
#import "LineMath.h"

@interface DropView()

@property (strong, nonatomic) CAShapeLayer  *dropShapLayer;
@property (strong, nonatomic) UIBezierPath  *bezierPath;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) PointView     *centerPointView;

@property (strong, nonatomic) DropView              *smallDrop;
@property (strong, nonatomic) AssistantCanvasView   *assistantCanvasView;
@property (assign, nonatomic) BOOL                  createSmallDrop;

@end

@implementation DropView


- (void)drawRect:(CGRect)rect
{
    if (_createSmallDrop == YES) {
        [self createAssistantCanvas];
    }
}

- (void)createAssistantCanvas
{
    if (!_assistantCanvasView) {
        UIView *superView = [self superview];
        _assistantCanvasView = [[AssistantCanvasView alloc] initWithFrame:superView.bounds];
        _assistantCanvasView.backgroundColor = [UIColor clearColor];
        _assistantCanvasView.userInteractionEnabled = NO;
        [superView addSubview:_assistantCanvasView];
    }
}


- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    [self createDropView];
    [self createCenterPointView];
    
    _createSmallDrop = createSmallDrop;
    if (_createSmallDrop == YES) {
        [self createSmallDropView];
        [self createPanGesture];
    }
    
    return self;
}

- (void)createDropView
{
    _dropShapLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_dropShapLayer];
    
    _bezierPath = [UIBezierPath bezierPath];
    [_bezierPath addArcWithCenter:CGPointMake(self.centerX, self.centerY) radius:self.width/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _dropShapLayer.path = _bezierPath.CGPath;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAssistantCanvas)];
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
        [self updateAssistantCanvas];
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
                             [self updateAssistantCanvas];
                         }
                         completion:^(BOOL finished) {
                             _displayLink.paused = YES;
                         }];
    }
}


- (void)updateAssistantCanvas
{
    [_assistantCanvasView.lineArray removeAllObjects];
    
    _center_point = CGPointMake(self.width/2, self.height/2);
    CALayer *smallDrop_layer = _smallDrop.layer.presentationLayer;
    LineMath *lineCenter2Center = [[LineMath alloc] initWithPoint1:_center_point point2:smallDrop_layer.position inView:self];
    [_assistantCanvasView.lineArray addObject:lineCenter2Center];
    
    [_assistantCanvasView setNeedsDisplay];
}


@synthesize fillColor = _fillColor;
- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    _dropShapLayer.fillColor = fillColor.CGColor;
}

@end





