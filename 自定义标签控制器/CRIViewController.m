//
//  CRIViewController.m
//  自定义标签控制器
//
//  Created by LLQ on 16/4/28.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "CRIViewController.h"

//标签栏的宽度
#define kTabBarWidth self.tabBar.frame.size.width
//标签栏的高度
#define kTabBarHeight self.tabBar.frame.size.height
//标签栏宽度除以标签栏上面视图控制器的个数（按钮个数） = 按钮宽度
#define kButtonWidth kTabBarWidth/self.viewControllers.count

@interface CRIViewController (){
    
    //添加一个图片视图，用来存储标签控制器的选中图片，并且可以添加到标签栏上面，设置为标签栏的选中图片
    UIImageView *_selectImgV;
    
}

//创建一个数组，用来管理标签栏的按钮
@property(nonatomic,strong)NSMutableArray *tabBarButtons;

@end

@implementation CRIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//当控制器的tabbar执行setSelectionIndicatorImage:方法（标签控制器选中图片的set方法）时我们才能获取到选中图片但是我们无法到tabbar中去复写这个set方法，所以我们在标签控制器将要显示的方法中设置标签控制器的选中图片
//这时，所有控制器加载完成，控制器个数，按钮宽度，选中的控制器都已经确定
-(void)viewWillAppear:(BOOL)animated{
    //实现父类的此方法
    [super viewWillAppear:animated];
    
    //判断是否设置了选中图片
    UIImage *selectionIndicatorImage = self.tabBar.selectionIndicatorImage;
    if (selectionIndicatorImage == nil) {
        
        //如果没有设置，则什么也不做
        return;
    }
    //如果设置了，就将这张图片作为选中图片添加到标签控制器上面
    
    //将图片添加到图片视图
    _selectImgV = [[UIImageView alloc] initWithImage:selectionIndicatorImage];
    //设置位置与大小
    // X 为当前选中的视图控制器的下标*按钮宽度，宽为按钮宽，高为按钮高
    _selectImgV.frame = CGRectMake(self.selectedIndex * kButtonWidth, 0, kButtonWidth, kTabBarHeight);
    //添加到self.tabBar上面，添加到最底层，防止盖住按钮
    [self.tabBar insertSubview:_selectImgV atIndex:0];
    
    //将选中的视图控制器所对应的按钮设置为选中状态
    //从按钮数组中取出按钮，设置为选中
    UIButton *selectButton = self.tabBarButtons[self.selectedIndex];
    selectButton.selected = YES;
}

//复写标签控制器的初始化方法，用来初始化存放按钮的可变数组
-(instancetype)init{
    
    self = [super init];
    if (self) {
        _tabBarButtons = [[NSMutableArray alloc] init];
    }
    
    return self;
}


//复写标签控制器的子控制器数组的set方法
-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    
    [super setViewControllers:viewControllers];
    
    //清除标签控制器上的所有子视图
    for (UIView *subView in self.tabBar.subviews) {
        //从父视图上移除（注意移除的是标签栏上面的button等控件，由于标签栏上面创建的UITabBarButton是内部类，我们无法使用，所以全部移除）
        [subView removeFromSuperview];
    }
    //给标签栏添加按钮
    for (int i = 0; i<viewControllers.count; i++) {
        //创建一个自定义的Button，X为第几个按钮*按钮宽度，宽度为按钮宽度，高度为标签栏高度
        VerticalButton *button = [[VerticalButton alloc] initWithFrame:CGRectMake(i*kButtonWidth, 0, kButtonWidth, kTabBarHeight)];
        //取到添加到标签栏的视图控制器的标题图片、标题选中图片、标题
        UIViewController *subVC = self.viewControllers[i];
        UIImage *image = subVC.tabBarItem.image;
        UIImage *selectImage = subVC.tabBarItem.selectedImage;
        NSString *title = subVC.tabBarItem.title;
        //将取到的图片与标题设置给Button
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:selectImage forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateNormal];
        
        
        
        //将按钮添加进标签栏
        [self.tabBar addSubview:button];
        
        //将按钮交给数组管理
        [_tabBarButtons addObject:button];
        
        //给按钮添加点击事件
        [button addTarget:self action:@selector(selectedVC:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

//点击按钮触发的事件方法
//此方法控制切换标签控制器的各个视图控制器，并完成标签控制器选中图片的动画效果
-(void)selectedVC:(UIButton *)button{
    
    //用按钮数组的下标控制选中的视图控制器
    self.selectedIndex = [_tabBarButtons indexOfObject:button];
    
    //遍历按钮数组，将所有按钮选中状态改为NO
    for (UIButton *btn in _tabBarButtons) {
        btn.selected = NO;
    }
    //将当前的按钮改为YES
    button.selected = YES;
    
    //添加标签控制器的选中动画
    [UIView animateWithDuration:0.3 animations:^{
        
        //让标签控制器的选中图片的 X 改变为 当前选中的视图控制器的下标*按钮宽度
        _selectImgV.frame = CGRectMake(self.selectedIndex * kButtonWidth, 0, _selectImgV.frame.size.width, _selectImgV.frame.size.height);
        
    }];
    
    
}







@end



#pragma make---------------垂直布局的Button类

//延展
@interface VerticalButton ()
{
    UILabel *_subLabel;//按钮标题
    UIImageView *_subImageView;//按钮图片视图
    UIImage *_normalImg;//用来存储默认状态下的图片
    UIImage *_selectImg;//用来存储选中状态下的图片
}
@end

@implementation VerticalButton

//复写init方法来添加Button的子视图
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //创建标题
        //宽为Button的宽，高为Button的0.3倍
        _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.3)];
        //设置属性
        _subLabel.textAlignment = NSTextAlignmentCenter;
        _subLabel.textColor = [UIColor whiteColor];
        _subLabel.font = [UIFont systemFontOfSize:12];
        //创建图片视图
        //Y为按钮标题的高度，宽为按钮的宽度，高为按钮剩余长度
        _subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _subLabel.frame.size.height, frame.size.width, frame.size.height*0.7)];
        //设置属性
        //图片居中
        _subImageView.contentMode = UIViewContentModeCenter;
        //添加入Button
        [self addSubview:_subImageView];
        [self addSubview:_subLabel];
    }
    
    return self;
}


//因为我们的属性是在 .m 中定义的私有属性，从外部获取不到，所以我们复写Button的setImage方法来保存用户设置的按钮普通状态下的图片和按钮选中状态下的图片
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    
    //由于我们想要设置自定义的图片，所以我们不用实现父类的set方法
//    [super setImage:image forState:state];
    
    if (state == UIControlStateNormal) {
        //保存普通状态下按钮图片
        //设置为不被渲染
        _normalImg = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //将图片设置给Button的图片视图（注意：此时点击按钮不会切换按钮的普通状态下的图片与选中状态下的图片）
        [_subImageView setImage:_normalImg];
    }else if (state == UIControlStateSelected){
        //保存选中图片
        //设置为不被渲染
        _selectImg = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
}

//复写标题的set方法，用于从外部获取标题，设置给自定义的Label
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    //设置自定义的标题Label，弃用父类的set方法
//    [super setTitle:title forState:state];
    
    if (state == UIControlStateNormal) {
        //给自定义的Label的text赋值
        [_subLabel setText:title];
    }
    
}

//复写Button的选中状态的set方法
//每次切换选中状态，Button的自定义的默认图片与选中图片都要切换
-(void)setSelected:(BOOL)selected{
    
    //实现父类的选中状态的set方法
    [super setSelected:selected];
    
    //判断选中状态
    if (selected == YES) {
        //如果为选中，图片就为选中图片
        _subImageView.image = _selectImg;
    }else{
        //如果为非选中，图片就为默认图片
        _subImageView.image = _normalImg;
    }
}

@end
