//
//  AssistantView.m
//  DropAnimation
//
//  Created by Bear on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AssistantView.h"
#import "LineMath.h"

@implementation AssistantView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    _lineArray = [[NSMutableArray alloc] init];
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    for (LineMath *lineMath in _lineArray) {
        CGPoint point1 = [lineMath.InView convertPoint:lineMath.point1 toView:self];
        CGPoint point2 = [lineMath.InView convertPoint:lineMath.point2 toView:self];
        [self drawLineWithLayer:point1 endPoint:point2 lineWidth:1.0f lineColor:[UIColor blackColor]];
    }
}

@end
