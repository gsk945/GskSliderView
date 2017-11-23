# GskSliderView
1.一侧滑的类，希望能帮到大家(项目要求侧滑之后，右边需要一个模糊处理，没有找到满意的，所以自己写了一个，分享给大家，小菜菜求别喷)


2.由于是从项目中抽离出来的，所以效果需要自己去添加


3.有问题可以联系我 gsk945@163.com(请别吝啬你们的star)


效果展示：

![](https://github.com/gsk945/GskSliderView/blob/master/SliderDemo/Resource/侧滑.gif)

#   用法简介
// 只需在APPdelegate.m中执行
ViewController *vc = [[ViewController alloc]init];

LeftViewController *leftVc = [[LeftViewController alloc]init];

GskSliderViewController *sliderVC = [[GskSliderViewController alloc]initWithLeftVC:leftVc rightVC:vc];

self.window.rootViewController = sliderVC;

// 具体用法请看demo
