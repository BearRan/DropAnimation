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
    CGPoint smallDrop_center = [dropView convertPoint:dropView.smallDrop.center toView:self];
    
    //  绘制主DropView
    CGFloat centerDistance = [LineMath calucateDistanceBetweenPoint1:mainDrop_center withPoint2:smallDrop_center];
    if (centerDistance > (dropView.width - dropView.smallDrop.width)/2) {
        NSLog(@"超出");
        
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
        [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:tempAngle endAngle:tempAngle + M_PI clockwise:YES];

    }else{
        NSLog(@"在里面");
        [dropView.bezierPath removeAllPoints];
        [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.width/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    }
    
    dropView.dropShapLayer.path = dropView.bezierPath.CGPath;
    
    for (LineMath *lineMath in _lineArray) {
        CGPoint point1 = [lineMath.InView convertPoint:lineMath.point1 toView:self];
        CGPoint point2 = [lineMath.InView convertPoint:lineMath.point2 toView:self];
        [self drawLineWithLayer:point1 endPoint:point2 lineWidth:1.0f lineColor:[UIColor blackColor]];
    }
}

@end



