//
//  ViewController.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "DropCanvasView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DropCanvasView *dropCanvasView = [[DropCanvasView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:dropCanvasView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
