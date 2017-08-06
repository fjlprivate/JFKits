# JFKitDemo

异步图文混排工具；

原理: 在view.layer的display方法中，异步创建context，并用core text方法将text绘制到context，UIImage类型的图片也绘制到context，
然后由context生成绘制完毕的image，回到主线程，赋给layer的contents属性;
网络图片使用SDWebImage库来实现异步加载;


下面是异步图文混排的例子截图:

![JFKitDemo截图](https://github.com/fjlprivate/JFKitDemo/raw/master/ScreenShots/demo.png)


# JFAsyncDisplayView
异步图文加载视图容器；（典型的用法是: [cell.contentView addSubview:asyncDisplayView];）

给layout属性赋值，就会引发图文内容的异步绘制；layout详见下面 **JFLayout**

本图文绘制容器还提供了2个协议方法，用于在图文执行绘制前后的指定自定义绘制任务，用于绘制指定区域的背景色或边框：

> // 绘制前任务；可以在context中绘制指定区域的背景色或其他内容；
> - (void) asyncDisplayView:(JFAsyncDisplayView*)asyncView willBeginDrawingInContext:(CGContextRef)context;

> // 绘制后任务；可以在context中绘制边框等任务；
> - (void) asyncDisplayView:(JFAsyncDisplayView*)asyncView willEndDrawingInContext:(CGContextRef)context;


# JFLayout
异步图文加载容器的排版布局对象；(典型的用法是: 作为UITableView的DataSource数据节点)
该对象缓存了所有需要绘制的text缓存对象(JFTextStorage)，以及image缓存对象(JFImageStorage)；

添加缓存的方法:
> - (void) addStorage:(JFStorage*)storage;

text缓存对象或image缓存对象在初始化时，都会设置它们的frame；
通过累加这些frame的bottom，得到的最大的bottom值，保存到 **bottom** 属性；

需要注意的是: 最好先生成layout对象，然后根据bottom值设置 **JFAsyncDisplayView** 的高度值；(典型的场景是在cell的高度定制)

# JFTextStorage & JFImageStorage
text缓存对象和image缓存对象都继承自父类:**JFStorage**;
包含frame等布局属性;

JFTextStorage 包含了文本的字体、颜色、背景色、选中高亮颜色，文本行数、行间距、字间距等属性；

给文本的指定位置，添加图片附件:
> - (void) setImage:(UIImage*)image imageSize:(CGSize)imageSize atPosition:(NSInteger)position;

给文本的指定位置添加点击事件:
>- (void) addLinkWithData:(id)data
       textSelectedColor:(UIColor*)textSelectedColor
       backSelectedColor:(UIColor*)backSelectedColor
                 atRange:(NSRange)range;

