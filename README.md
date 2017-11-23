# GskSliderView
一侧滑的类，希望能帮到大家(项目要求侧滑之后，右边需要一个模糊处理，自己写了一个，小菜菜求别喷)
效果展示：
![](https://github.com/gsk945/GskSliderView/blob/master/SliderDemo/Resource/侧滑.gif)

部分代码实现：
ViewController *vc = [[ViewController alloc]init];
LeftViewController *leftVc = [[LeftViewController alloc]init];
GskSliderViewController *sliderVC = [[GskSliderViewController alloc]initWithLeftVC:leftVc rightVC:vc];
self.window.rootViewController = sliderVC;
