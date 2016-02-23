//
//  CircleMath.m
//  DropAnimation
//
//  Created by Bear on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CircleMath.h"
#import "LineMath.h"

@implementation CircleMath

- (instancetype)initWithCenterPoint:(CGPoint)centerPoint radius:(CGFloat)radius inView:(UIView *)inView
{
    self = [super init];
    if (!self) {
        self = nil;
    }
    
    _centerPoint    = centerPoint;
    _radius         = radius;
    _InView         = inView;
    
    return self;
}

- (void)calucateCircleWithLineAccross:(LineMath *)line
{
    CGFloat x_Line;
    CGFloat y_Line;
    y_Line = line.k * x_Line + line.b;
    
    CGFloat x_Cir;
    CGFloat y_Cir;
    
}

@end
