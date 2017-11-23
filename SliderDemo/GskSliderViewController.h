//
//  GskSliderViewController.h
//  GskSliderViewController
//
//  Created by gsk on 2017/10/26.
//  Copyright © 2017年 gsk. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GskSliderViewController : UIViewController
/**
 左侧控制器
 */
@property(nonatomic , strong) UIViewController * leftVC;
/**
 右侧控制器
 */
@property(nonatomic , strong) UIViewController * rightVC;
/**
 指定初始化方法
 */
-(instancetype)initWithLeftVC:(UIViewController*)leftVC rightVC:(UIViewController*)rightVC;
-(void)closeLeft;
-(void)showLeftWithWidth;
@end
