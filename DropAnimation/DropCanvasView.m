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
    
    _assistantView = [[AssistantView alloc] initWithFrame:frame];
    _assistantView.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.2 alpha:0.2];
    [self addSubview:_assistantView];
    
    self.backgroundColor = [UIColor clearColor];
    [self createMainDrop];
    
    return self;
}

- (void)createMainDrop
{
    CGFloat mainDrop_width = 150;
    _mainDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, mainDrop_width, mainDrop_width) createSmallDrop:YES];
    _mainDrop.dropSuperView = self;
    [self addSubview:_mainDrop];
    [_mainDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self.assistantView setNeedsDisplay];
    [self drawDropView:_mainDrop];
}

- (void)drawDropView:(DropView *)dropView
{
    CGPoint mainDrop_center = dropView.center;
    CGPoint smallDrop_center = [dropView convertPoint:dropView.smallDrop.center toView:self];
    
    //  绘制主DropView
    CGFloat centerDistance = [LineMath calucateDistanceBetweenPoint1:mainDrop_center withPoint2:smallDrop_center];
    if (centerDistance > (dropView.width - dropView.smallDrop.width)/2) {
        NSLog(@"超出");
    }else{
        NSLog(@"在里面");
        [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.width/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        dropView.dropShapLayer.path = dropView.bezierPath.CGPath;
        dropView.fillColor = [UIColor orangeColor];
        
        [self.layer addSublayer:dropView.dropShapLayer];
    }
}

@end



