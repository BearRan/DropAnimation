//
//  DropCanvasView.m
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropCanvasView.h"
#import "DropView.h"
#import "LineMath.h"

@interface DropCanvasView()
@property (strong, nonatomic) DropView          *mainDrop;

@end


@implementation DropCanvasView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    _lineArray = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    [self createMainDrop];
    
    return self;
}

- (void)createMainDrop
{
    CGFloat mainDrop_width = 150;
    _mainDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, mainDrop_width, mainDrop_width) createSmallDrop:YES];
    _mainDrop.dropSuperView = self;
    [self.layer addSublayer:_mainDrop.dropShapLayer];
    [self addSubview:_mainDrop];
    [_mainDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    DropView *dropView = _mainDrop;
//    CGPoint mainDrop_center = dropView.center;
//    CGFloat tempAngle = atan(dropView.lineCenter2Center.k);
//    CGFloat sina = sin(tempAngle);
//    CGFloat cosa = cos(tempAngle);
//    CGFloat degrees = radiansToDegrees(tempAngle);
//    NSLog(@"sina:%f consa:%f", sina, cosa);
//    NSLog(@"tempAngle:%f", tempAngle);
//    NSLog(@"degrees:%f", degrees);
//    
//    [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:degrees endAngle:degrees + 90 clockwise:YES];
    //        dropView.dropShapLayer.path = dropView.bezierPath.CGPath;
    //        dropView.dropShapLayer.borderColor = [UIColor redColor].CGColor;
    //        dropView.dropShapLayer.borderWidth = 2.0f;
    //        dropView.fillColor = [UIColor redColor];
    
    [self drawDropView:_mainDrop];
}

//  角度转弧度
#define degreesToRadian(x) (M_PI * x / 180.0)

//  弧度转角度
#define radiansToDegrees(x) (180.0 * x / M_PI)


/***********************
 角度说明
 
             90度
             |
             |
             |
             |
 0度  ----------------  180度
             |
 －30或者330  |
             |
             |
             270 度
 
 **************************/

- (void)drawDropView:(DropView *)dropView
{
    CGPoint mainDrop_center = dropView.center;
    CALayer *smallDrop_layer = dropView.smallDrop.layer.presentationLayer;
    CGPoint smallDrop_center = [dropView convertPoint:smallDrop_layer.position toView:self];
    
    CGPoint mainEdgePoint1 = [dropView convertPoint:dropView.edge_point1 toView:self];
    CGPoint mainEdgePoint2 = [dropView convertPoint:dropView.edge_point2 toView:self];
    CGPoint smallEdgePoint1 = [dropView convertPoint:dropView.smallDrop.edge_point1 toView:self];
    CGPoint smallEdgePoint2 = [dropView convertPoint:dropView.smallDrop.edge_point2 toView:self];
    
    //  绘制主DropView
    CGFloat centerDistance = [LineMath calucateDistanceBetweenPoint1:mainDrop_center withPoint2:smallDrop_center];
    if (centerDistance > (dropView.circleMath.radius + dropView.smallDrop.circleMath.radius)) {
//        NSLog(@"超出");
        
        CGFloat tempAngle = atan(dropView.lineCenter2Center.k);
        
        //  垂直平分线的斜率k矫正
        //  第一象限
        if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y > smallDrop_center.y) {
            tempAngle += M_PI/2;
        }
        //  第二象限
        else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y > smallDrop_center.y){
            tempAngle -= M_PI/2;
        }
        //  第三象限
        else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
            tempAngle -= M_PI/2;
        }
        //  第四象限
        else if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
            tempAngle += M_PI/2;
        }
        
        [dropView.bezierPath removeAllPoints];
        
        //  MainDrop 半圆
        [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:tempAngle endAngle:tempAngle + M_PI clockwise:YES];
        
        //  MainDrop->SmallDrop贝赛尔曲线
        CGPoint controlPoint = CGPointMake((mainDrop_center.x + smallDrop_center.x)/2, (mainDrop_center.y + smallDrop_center.y)/2);
        
        [dropView.bezierPath addQuadCurveToPoint:smallEdgePoint2 controlPoint:controlPoint];
        
        //  SmallDrop 半圆
        [dropView.bezierPath addArcWithCenter:smallDrop_center radius:dropView.smallDrop.circleMath.radius startAngle:tempAngle + M_PI endAngle:tempAngle clockwise:YES];
        
        //  SmallDrop->MainDrop贝赛尔曲线
        [dropView.bezierPath addQuadCurveToPoint:mainEdgePoint1 controlPoint:controlPoint];

    }else{
//        NSLog(@"在里面");
        [dropView.bezierPath removeAllPoints];
        
        //  MainDrop半圆
        LineMath *lineP1_MainCenter = [[LineMath alloc] initWithPoint1:mainEdgePoint1 point2:mainDrop_center inView:self];
        LineMath *lineP2_MainCenter = [[LineMath alloc] initWithPoint1:mainEdgePoint2 point2:mainDrop_center inView:self];
        
        __block CGFloat angleLine_MainP1 = atan(lineP1_MainCenter.k);
        __block CGFloat angleLine_MainP2 = atan(lineP2_MainCenter.k);
        
        //  两圆焦点和圆心连线的line的 斜率矫正
        [self eventInDiffQuadrantWithCenterPoint:mainDrop_center withParaPoint:mainEdgePoint1 quadrantFirst:^{
            nil;
        } quadrantSecond:^{
            angleLine_MainP1 -= M_PI;
        } quadrantThird:^{
            angleLine_MainP1 -= M_PI;
        } quadrantFourth:^{
            nil;
        }];
        
        [self eventInDiffQuadrantWithCenterPoint:mainDrop_center withParaPoint:mainEdgePoint2 quadrantFirst:^{
            nil;
        } quadrantSecond:^{
            angleLine_MainP2 -= M_PI;
        } quadrantThird:^{
            angleLine_MainP2 -= M_PI;
        } quadrantFourth:^{
            nil;
        }];
        
        [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:angleLine_MainP1 endAngle:angleLine_MainP2 clockwise:YES];
        
        
        //  SmallDrop半圆
        LineMath *lineP1_SmallCenter = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:smallDrop_center inView:self];
        LineMath *lineP2_SmallCenter = [[LineMath alloc] initWithPoint1:smallEdgePoint2 point2:smallDrop_center inView:self];
        
        __block CGFloat angleLine_SmallP1 = atan(lineP1_SmallCenter.k);
        __block CGFloat angleLine_SmallP2 = atan(lineP2_SmallCenter.k);
        
        //  两圆焦点和圆心连线的line的 斜率矫正
        [self eventInDiffQuadrantWithCenterPoint:smallDrop_center withParaPoint:smallEdgePoint1 quadrantFirst:^{
            nil;
        } quadrantSecond:^{
            angleLine_SmallP1 -= M_PI;
        } quadrantThird:^{
            angleLine_SmallP1 -= M_PI;
        } quadrantFourth:^{
            nil;
        }];
        
        [self eventInDiffQuadrantWithCenterPoint:smallDrop_center withParaPoint:smallEdgePoint2 quadrantFirst:^{
            nil;
        } quadrantSecond:^{
            angleLine_SmallP2-= M_PI;
        } quadrantThird:^{
            angleLine_SmallP2 -= M_PI;
        } quadrantFourth:^{
            nil;
        }];
        
        [dropView.bezierPath addArcWithCenter:smallDrop_center radius:dropView.smallDrop.circleMath.radius startAngle:angleLine_SmallP2 endAngle:angleLine_SmallP1 clockwise:YES];
    }
    
    dropView.dropShapLayer.path = dropView.bezierPath.CGPath;
    
    for (LineMath *lineMath in _lineArray) {
        CGPoint point1 = [lineMath.InView convertPoint:lineMath.point1 toView:self];
        CGPoint point2 = [lineMath.InView convertPoint:lineMath.point2 toView:self];
        [self drawLineWithLayer:point1 endPoint:point2 lineWidth:1.0f lineColor:[UIColor blackColor]];
    }
}


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
- (void)eventInDiffQuadrantWithCenterPoint:(CGPoint)centerPoint
                             withParaPoint:(CGPoint)paraPoint
                             quadrantFirst:(void (^)())quadrantFirst
                            quadrantSecond:(void (^)())quadrantSecond
                             quadrantThird:(void (^)())quadrantThird
                            quadrantFourth:(void (^)())quadrantFourth
{
    //  第一象限
    if (centerPoint.x < paraPoint.x && centerPoint.y > paraPoint.y) {
        if (quadrantFirst) {
            quadrantFirst();
        }
    }
    //  第二象限
    else if (centerPoint.x > paraPoint.x && centerPoint.y > paraPoint.y){
        if (quadrantSecond) {
            quadrantSecond();
        }
    }
    //  第三象限
    else if (centerPoint.x > paraPoint.x && centerPoint.y < paraPoint.y){
        if (quadrantThird) {
            quadrantThird();
        }
    }
    //  第四象限
    else if (centerPoint.x < paraPoint.x && centerPoint.y < paraPoint.y){
        if (quadrantFourth) {
            quadrantFourth();
        }
    }
}

@end



