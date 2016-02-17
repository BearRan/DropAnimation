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
@property (strong, nonatomic) UIView        *pointView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createMainDrop];
    [self createPointView];
}

- (void)createMainDrop
{
    CGFloat mainDrop_width = 150;
    _mainDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, mainDrop_width, mainDrop_width)];
    [self.view addSubview:_mainDrop];
    [_mainDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)createPointView
{
    CGFloat pointView_width = 6;
    _pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pointView_width, pointView_width)];
    _pointView.backgroundColor = [UIColor redColor];
    _pointView.layer.cornerRadius = pointView_width/2;
    [_mainDrop addSubview:_pointView];
    [_pointView BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
