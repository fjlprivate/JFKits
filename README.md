# '异步图文混排框架' ： JFAsyncDisplayKit


## 用法

* 创建视图:JFAsyncView

JFAsyncView 的布局和内容由 JFAsyncViewLayouts 来提供；

* 生成JFAsyncViewLayouts

JFAsyncViewLayouts由多个JFLayout组成；
添加完所有的JFLayout后，要更新 JFAsyncViewLayouts.viewFrame；

* 生成JFTextLayout(JFLayout)

封装了一段text的属性，包括布局属性left、top、width、height，还有边框、文字颜色、字体、背景色等；
文本还可以添加附件：高亮附件(JFTextAttachmentHighlight)、图片附件(JFTextAttachmentImage)；

* 生成JFImageLayout(JFLayout)

封装了image的属性；最终在 JFAsyncView 中的加载由 JFImageView 完成；
