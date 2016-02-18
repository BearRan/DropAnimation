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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    for (LineMath *lineMath in _lineArray) {
        CGPoint point1 = [lineMath.InView convertPoint:lineMath.point1 toView:self];
        CGPoint point2 = [lineMath.InView convertPoint:lineMath.point2 toView:self];
        [self drawLineWithLayer:point1 endPoint:point2 lineWidth:1.0f lineColor:[UIColor blackColor]];
    }
    NSLog(@"--1");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    _lineArray = [[NSMutableArray alloc] init];
    
    [self createMainDrop];
    
    return self;
}

- (void)createMainDrop
{
    CGFloat mainDrop_width = 150;
    _mainDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, mainDrop_width, mainDrop_width) createSmallDrop:YES];
    _mainDrop.fillColor = [UIColor orangeColor];
    _mainDrop.dropSuperView = self;
    [self addSubview:_mainDrop];
    [_mainDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

@end
