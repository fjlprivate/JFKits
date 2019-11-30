# '异步图文混排框架' ： JFAsyncDisplayKit

![image](https://github.com/fjlprivate/JFKits/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20-%202019-11-29%20at%2017.34.22.png)

## 用法

* 创建视图:JFAsyncView

JFAsyncView 的布局和内容由 JFAsyncViewLayouts 来提供；
```
JFAsyncView* asyncView = [[JFAsyncView alloc] init];
asyncView.layouts = layouts; // layouts : JFAsyncViewLayouts
```

* 生成JFAsyncViewLayouts

JFAsyncViewLayouts由多个JFLayout组成；
添加完所有的JFLayout后，要更新 JFAsyncViewLayouts.viewFrame；
```
JFAsyncViewLayouts* layouts = [JFAsyncViewLayouts new];
[layouts addLayout:textLayout]; // 添加一个文本布局
[layouts addLayout:textLayout]; 
[layouts addLayout:imageLayout]; // 添加一个图片布局
...
[layouts addLayout:imageLayout]; // 添加一个图片布局
CGFloat bottom = imageLayout.bottom; // 保存最底部的值，作为整个frame的高度

layouts.viewFrame = CGRectMake(0,0,width, bottom);
```

* 生成JFTextLayout(JFLayout)

封装了一段text的属性，包括布局属性left、top、width、height，还有边框、文字颜色、字体、背景色等；
文本还可以添加附件：高亮附件(JFTextAttachmentHighlight)、图片附件(JFTextAttachmentImage)；
```
NSString* text = @"我是一段文本布局";
JFTextStorage* storage = [JFTextStorage storageWithText:text];
storage.textColor = [UIColor blackColor];
storage.font = [UIFont systemFontOfSize:14];
storage.lineSpacing = 3; // 行间距
[storage addHighlight:highlight]; // 添加一个高亮附件JFTextAttachmentHighlight；高亮区间的文字支持点击事件；
[storage addImage:imageAttachment]; // 添加一个图片附件；可以将图片插在指定的区间；

JFTextLayout* textLayout = [JFTextLayout textLayoutWithText:storage];
textLayout.left = 15;
textLayout.top = 15;
textLayout.width = 100;
textLayout.height = 50; // setter会引发JFTextLayout的relayouting，会重新生成真实的height和width
textLayout.insets = UIEdgeInsets(2,10,2,10);
textLayout.backgroundColor = [UIColor whiteColor];
```

* 生成JFImageLayout(JFLayout)

封装了image的属性；最终在 JFAsyncView 中的加载由 JFImageView 完成；
