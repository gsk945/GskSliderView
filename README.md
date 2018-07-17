# GskSliderView
1. 一个侧滑的类，希望能帮到大家（项目要求侧滑之后，右边部分需要一个模糊处理）
2. 由于是从项目中抽离出来的，效果没有展示图那么好，请见谅


![](https://github.com/gsk945/GskSliderView/blob/master/SliderDemo/Resource/侧滑.gif)
## 用法
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor =[UIColor whiteColor];
    ViewController *vc = [[ViewController alloc]init];
    LeftViewController *leftVc = [[LeftViewController alloc]init];
    GskSliderViewController *sliderVC = [[GskSliderViewController alloc]initWithLeftVC:leftVc rightVC:vc];
    self.window.rootViewController = sliderVC;

    return YES;
}
```
