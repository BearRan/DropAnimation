//
//  LineMath.h
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//


//  角度转弧度
#define degreesToRadian(x) (M_PI * x / 180.0)

//  弧度转角度
#define radiansToDegrees(x) (180.0 * x / M_PI)


#import <Foundation/Foundation.h>

@interface LineMath : NSObject

@property (assign, nonatomic) CGPoint point1;
@property (assign, nonatomic) CGPoint point2;
@property (assign, nonatomic) CGFloat degrees;
@property (strong, nonatomic) UIView  *InView;

//  直线方程 y=kx+b;
@property (assign, nonatomic) CGFloat k;
@property (assign, nonatomic) CGFloat b;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;

- (instancetype)initWithPoint1:(CGPoint)point1 point2:(CGPoint)point2 inView:(UIView *)inView;

//  计算两点间的距离
+ (CGFloat)calucateDistanceBetweenPoint1:(CGPoint)point1 withPoint2:(CGPoint)point2;

//  计算两条线的交点
+ (CGPoint)calucateAcrossPointBetweenLine1:(LineMath *)line1 withLine2:(LineMath *)line2;

@end
