//
//  DropView.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropView.h"

@implementation DropView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    [self createDropShapeLayer];
    
    return self;
}

- (void)createDropShapeLayer
{
    _dropShapLayer = [CAShapeLayer layer];
    _dropShapLayer.fillColor = [UIColor orangeColor].CGColor;
    [self.layer addSublayer:_dropShapLayer];
    
    _bezierPath = [UIBezierPath bezierPath];
    [_bezierPath addArcWithCenter:CGPointMake(self.centerX, self.centerY) radius:self.width/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _dropShapLayer.path = _bezierPath.CGPath;
}

@end
