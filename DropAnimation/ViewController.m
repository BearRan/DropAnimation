//
//  ViewController.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "DropView.h"

@interface ViewController ()

@property (strong, nonatomic) DropView      *mainDrop;
@property (strong, nonatomic) DropView      *smallDrop;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createMainDrop];
    [self createSmallDrop];
    [self createPanGesture];
}

- (void)createMainDrop
{
    CGFloat mainDrop_width = 150;
    _mainDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, mainDrop_width, mainDrop_width)];
    _mainDrop.dropShapLayer.fillColor = [UIColor orangeColor].CGColor;
    [self.view addSubview:_mainDrop];
    [_mainDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)createSmallDrop
{
    CGFloat smallDrop_width = 6;
    _smallDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, smallDrop_width, smallDrop_width)];
    _smallDrop.dropShapLayer.fillColor = [UIColor redColor].CGColor;
    [_mainDrop addSubview:_smallDrop];
    [_smallDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)createPanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture_Event:)];
    [_mainDrop addGestureRecognizer:panGesture];
}

- (void)panGesture_Event:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint tempPoint = [panGesture locationInView:_mainDrop];
        _smallDrop.center = tempPoint;
    }
    else if(panGesture.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:0.3
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [_smallDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
}

- (void)updateMainDropPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
