//
//  LineMath.m
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LineMath.h"

@implementation LineMath

- (instancetype)initWithPoint1:(CGPoint)point1 point2:(CGPoint)point2 inView:(UIView *)inView
{
    self = [super init];
    if (!self) {
        self = nil;
    }
    
    _point1 = point1;
    _point2 = point2;
    _InView = inView;
    
    return self;
}

+ (CGFloat)calucateDistanceBetweenPoint1:(CGPoint)point1 withPoint2:(CGPoint)point2
{
    CGFloat x_dx    = (point2.x - point1.x);
    CGFloat X_DX2   = x_dx * x_dx;
    CGFloat y_dy    = (point2.y - point1.y);
    CGFloat Y_DY2   = y_dy * y_dy;
    CGFloat distance = sqrt(X_DX2 + Y_DY2);
    
    return distance;
}

@end
