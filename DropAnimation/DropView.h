//
//  DropView.h
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointView.h"

@interface DropView : UIView

@property (strong, nonatomic) CAShapeLayer  *dropShapLayer;
@property (strong, nonatomic) UIBezierPath  *bezierPath;
@property (strong, nonatomic) PointView     *centerPointView;

- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop;

@end
