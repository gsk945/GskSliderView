//
//  ViewController.m
//  SliderDemo
//
//  Created by gsk on 2017/11/23.
//  Copyright © 2017年 gsk. All rights reserved.
//

#import "ViewController.h"
#import "GskSliderViewController.h"
#define gskHeight [UIScreen mainScreen].bounds.size.height// 屏幕高度
#define gskWidth [UIScreen mainScreen].bounds.size.width// 屏幕宽度
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, gskWidth, gskHeight/2)];
    topView.backgroundColor = [UIColor purpleColor];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, gskHeight/2, gskWidth, gskHeight/2)];
    bottomView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];

    UIButton *showBut = [[UIButton alloc]initWithFrame:CGRectMake(0, gskHeight-([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49),70, 49)];
    [showBut setBackgroundImage:[UIImage imageNamed:@"newMe.jpg"] forState:UIControlStateNormal];
    [showBut addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBut];
}
-(void)butAction{
    GskSliderViewController *sliderVc = (GskSliderViewController *)self.parentViewController;
    [sliderVc showLeftWithWidth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
