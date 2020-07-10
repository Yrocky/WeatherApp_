##  首页解耦

在业务开发中，首页会有太多的耦合，特别是那种多页面嵌套的结构，UI结构类似，点击cell的效果类似，空白页类似等等，很多东西都需要共用

### 拆分

在拆分模块的时候，参考的是IGListKit。IGListKit中对UICollectionView的抽离是将每个小模块抽象成一个SectionController，并且在SectionController中决定具体的cell、insert、spacing、header、footer等等

该模式一共抽离出来`Module`、`DataSource`、`Component`和`Layout`四个角色，Component通过DataSource被Module管理，Layout通过Component为DataSource提供布局操作

### 整合


### OrthogonalScroll

常规的垂直方向展示功能已经不能满足多变的需求，像App Store中那种既可以纵向滑动又可以横向滑动的效果越来越受欢迎。

在具体实现中更多的是在具体需要横向滑动的cell中添加一个UICollectionView子视图，然后这个cell来实现具体的数据源和代理，不过好在iOS12之后，系统提供了一个关于UICollectionView的layout：`UICollectionViewCompositionalLayout`，这个layout可以设置丰富多样的布局样式。但，由于系统的限制，iOS12以下的系统不能使用，这在实际业务开发中就决定了这个功能组件暂时不会被大面积使用。

不过好在，社区中有根据系统的API自己实现了一套iOS12以下也可以用的Layout，由于这个Layout功能太多，这里只是参考了其中的一些实现逻辑，并没有直接拿来用，借鉴的就是实现OrthogonalScroll效果的部分。



