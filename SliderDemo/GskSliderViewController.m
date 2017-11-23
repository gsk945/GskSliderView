//
//  GskSliderViewController.m
//  GskSliderViewController
//
//  Created by gsk on 2017/10/26.
//  Copyright © 2017年 gsk. All rights reserved.
//

#import "GskSliderViewController.h"
#import <Accelerate/Accelerate.h>
#define gskHeight [UIScreen mainScreen].bounds.size.height// 屏幕高度
#define gskWidth [UIScreen mainScreen].bounds.size.width// 屏幕宽度
@interface GskSliderViewController ()
@property (nonatomic,strong)UITapGestureRecognizer *tap;//请点手势
@property (nonatomic,strong)UIPanGestureRecognizer *pan;//拖拽手势
@property (nonatomic,strong) UIView * maskView;
@property (nonatomic,strong)UIImageView *blurImageView;
@property (nonatomic,strong)UIImageView *arrImageView;
@end

@implementation GskSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreatUI];
}

#pragma mark - 指定初始化方法
-(instancetype)initWithLeftVC:(UIViewController*)leftVC rightVC:(UIViewController*)rightVC{
    
    if (self = [super init]) {
        self.leftVC = leftVC;
        self.rightVC = rightVC;
    }
    return self;
}
#pragma mark - 设置界面
-(void)CreatUI{
    
    _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    _blurImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    //使用抽屉的方式把左右两侧的控制器加进去
    [self addChildViewController:_leftVC];
    [self.view addSubview:_leftVC.view];
    [_leftVC didMoveToParentViewController:self];

    [self addChildViewController:_rightVC];
    [self.view addSubview:_rightVC.view];
    [_rightVC didMoveToParentViewController:self];

    //添加拖拽手势
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(slideRightView:)];
    [self.rightVC.view addGestureRecognizer:self.pan];
}

#pragma mark - 拖拽时触发
-(void)slideRightView:(UIPanGestureRecognizer *)pan{
    //取出拖拽偏移量
    CGPoint offset = [pan translationInView:self.view];
    //清0
    [pan setTranslation:CGPointZero inView:self.view];
    //防止右侧穿帮
    if(offset.x + _rightVC.view.frame.origin.x < 0){
        //避免拖动太猛会有间隙，写代码让它回到初始位置
        _rightVC.view.transform = CGAffineTransformIdentity;
        return;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            //访问右侧控制器
            _rightVC.view.transform = CGAffineTransformTranslate(_rightVC.view.transform, offset.x, 0);
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            
            //MARK: 滑动结束超过一半的情况
            //判断有没有超过一半
            if(_rightVC.view.frame.origin.x >= gskWidth * 0.5){
                [self showLeftWithWidth];
            }else{
                [self closeLeft];
            }
        default:
            break;
    }
}

#pragma mark - 显示左侧控制器
-(void)showLeftWithWidth{
    UIImage *image =  [self imageFromView:_rightVC.view];
    [UIView animateWithDuration:0.4 animations:^{
        _rightVC.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width - 70, 0);
    }];
    [self.rightVC.view addSubview:_maskView];
    [_maskView addSubview:_blurImageView];
    _blurImageView.image = image;
    _blurImageView.image = [self blurryImage:_blurImageView.image withBlurLevel:0.1];
    [_blurImageView addSubview:self.arrImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeft)];
    //添加到右侧控制器的View
    [_maskView addGestureRecognizer:tap];
    //记录tap属性
    _tap = tap;
}

#pragma mark - 关闭左侧控制器
-(void)closeLeft{
    [UIView animateWithDuration:0.4 animations:^{
        _rightVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        [_maskView removeGestureRecognizer:_tap];
    }];
}
#pragma mark - shot
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }

    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;

    CGImageRef img = image.CGImage;

    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;

    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);

    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));

    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);

    if (error) {
        NSLog(@"error from convolution %ld", error);
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));

    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);

    free(pixelBuffer);
    CFRelease(inBitmapData);

    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);

    return returnImage;
}
-(UIImageView *)arrImageView{
    if (!_arrImageView) {
        _arrImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, gskHeight-([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49),70, 49)];
        _arrImageView.image = [UIImage imageNamed:@"newMe.jpg"];
    }
    return _arrImageView;
}
@end
