//
//  ViewController.m
//  滑块式分页headView
//
//  Created by carshoel on 16/11/3.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "ViewController.h"
#import "AETitleSliderView.h"

@interface ViewController ()<AETitleSliderViewDelegate>

@property (nonatomic, weak)AETitleSliderView *titleView;
@property (nonatomic, weak)UILabel *clickResultL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //2 设置滑块标题
    [self setUpTitleView];
    
    //3 设置点击效果
    [self setUpTitleClick];
 
    //4 设置操作按钮
    [self setUpOperationBtns];
}

//设置滑块标题
- (void)setUpTitleView{
    CGFloat x = 0;
    CGFloat y = 25;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = 40;
    AETitleSliderView *titleView = [[AETitleSliderView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    NSArray *titles = @[@"第一组",@"第二组",@"第三组"];
    AETitleViewModel *model = [AETitleViewModel modelWithTitles:titles showWidht:w btnHeightScale:1 / 10.0];
    titleView.model = model;
    titleView.delegate = self;
    self.titleView = titleView;
    [self.view addSubview:titleView];
    
    titleView.frame = titleView.frame;
    
}

//设置点击效果
- (void)setUpTitleClick{
    CGFloat w = 220;
    CGFloat h = 30;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - w) * 0.5;
    CGFloat y = 200;
    UILabel *clickResultL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    clickResultL.text = @"点击标题，这里可显示结果";
    _clickResultL = clickResultL;
    clickResultL.backgroundColor = [UIColor redColor];
    clickResultL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:clickResultL];
}

//设置操作按钮
- (void)setUpOperationBtns{
    CGFloat w = 220;
    CGFloat h = 30;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - w) * 0.5;
    CGFloat y = CGRectGetMaxY(self.clickResultL.frame) + 25;
    
    UIButton *custOneBtn = [self btnWithTitle:@"自定义样式 1" frame:CGRectMake(x, y, w, h) action:@selector(customStyle1)];
    [self.view addSubview:custOneBtn];
    
    y = CGRectGetMaxY(custOneBtn.frame) + 25;
    UIButton *custTwoBtn = [self btnWithTitle:@"自定义样式 1" frame:CGRectMake(x, y, w, h) action:@selector(customStyle2)];
    [self.view addSubview:custTwoBtn];
    
    y = CGRectGetMaxY(custTwoBtn.frame) + 25;
    UIButton *nomalBtn = [self btnWithTitle:@"默认样式" frame:CGRectMake(x, y, w, h) action:@selector(normalStyle)];
    [self.view addSubview:nomalBtn];
    
    y = CGRectGetMaxY(nomalBtn.frame) + 25;
    UIButton *hiddenLineBtn = [self btnWithTitle:@"隐藏中间分割线" frame:CGRectMake(x, y, w, h) action:@selector(hiddenPartingLine)];
    [self.view addSubview:hiddenLineBtn];
    
    y = CGRectGetMaxY(hiddenLineBtn.frame) + 25;
    UIButton *changeHeightBtn = [self btnWithTitle:@"改变高度" frame:CGRectMake(x, y, w, h) action:@selector(changeHeight)];
    [self.view addSubview:changeHeightBtn];
}

//创建一个按钮
- (UIButton *)btnWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.masksToBounds = YES;
    
    return btn;
}

//样式一
- (void)customStyle1{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    NSArray *titles = @[@"第一组",@"组织架构成员",@"第三组"];
    AETitleViewModel *model = [AETitleViewModel modelWithTitles:titles showWidht:w btnHeightScale:5 / 10.0];
    model.sliderColor = [UIColor redColor];
    model.bjColor = [UIColor yellowColor];
    model.selectedBjColor = [UIColor blueColor];
    self.titleView.model = model;
    
    self.titleView.frame = self.titleView.frame;
}

//样式二
- (void)customStyle2{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    NSArray *titles = @[@"第一组",@"第二组",@"第三组",@"第四组",@"第五组",@"第六组"];
    AETitleViewModel *model = [AETitleViewModel modelWithTitles:titles showWidht:w btnHeightScale:2 / 10.0];
    model.sliderColor = [UIColor redColor];
    model.bjColor = [UIColor yellowColor];
    model.selectedBjColor = [UIColor blueColor];
    self.titleView.model = model;
    
    self.titleView.frame = self.titleView.frame;
}

//默认
- (void)normalStyle{
    NSArray *titles = @[@"第一组",@"第二组",@"第三组",@"第四组",@"第五组",@"第六组"];
    AETitleViewModel *model = [[AETitleViewModel alloc] init];
    model.titles = titles;
    self.titleView.model = model;
    
    self.titleView.frame = self.titleView.frame;
}

//隐藏分割线
- (void)hiddenPartingLine{
    AETitleViewModel *model = self.titleView.model;
    model.hiddenPartingLine = YES;
    self.titleView.model = model;
    
    self.titleView.frame = self.titleView.frame;
}

//改变高度
- (void)changeHeight{
    AETitleViewModel *model = self.titleView.model;
    
    model.btnHeightScale = 2 / 10.0;//改变控件的高度 （值 ＝ 高度 ／ 宽度） 注：高度和宽度至少一个为浮点型
    self.titleView.model = model;
    
    self.titleView.frame = self.titleView.frame;
}

#pragma mark - 滑动title代理
- (void)titleSliderView:(AETitleSliderView *)titleSliderView didSelectedTitlBtn:(UIButton *)btn{
    self.clickResultL.text = [NSString stringWithFormat:@"%d %@",btn.tag,btn.currentTitle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
