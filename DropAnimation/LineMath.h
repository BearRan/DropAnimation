//
//  LineMath.h
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineMath : NSObject

@property (assign, nonatomic) CGPoint point1;
@property (assign, nonatomic) CGPoint point2;
@property (strong, nonatomic) UIView  *InView;

//  直线方程 y=kx+b;
@property (assign, nonatomic) CGFloat k;
@property (assign, nonatomic) CGFloat b;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;

- (instancetype)initWithPoint1:(CGPoint)point1 point2:(CGPoint)point2 inView:(UIView *)inView;
+ (CGFloat)calucateDistanceBetweenPoint1:(CGPoint)point1 withPoint2:(CGPoint)point2;

@end
