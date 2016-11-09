//
//  AETitleSliderView.m
//  AETravel
//
//  Created by carshoel on 16/5/6.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "AETitleSliderView.h"
#import "UIImage+Stool.h"

//获得RGB颜色 50 63 75
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface AETitleSliderView ()

@property (nonatomic, weak)UIButton *selectedBtn;
@property (nonatomic, weak)UIButton *line;
@property (nonatomic, weak)UIButton *slider;

@end

@implementation AETitleSliderView

-(void)setSelectedBtn:(UIButton *)selectedBtn{

    if (_selectedBtn == selectedBtn)return;
    
    //选择按钮属性交接
    _selectedBtn.selected = NO;
    selectedBtn.selected = YES;
    _selectedBtn = selectedBtn;
    
    //滑块动画
    [UIView animateWithDuration:0.6 animations:^{
        self.slider.center = CGPointMake(_selectedBtn.center.x, self.slider.center.y);
    }];
    
}

- (void)titleBtnClick1:(UIButton *)btn{
    
    self.selectedBtn = btn;
    if ([self.delegate respondsToSelector:@selector(titleSliderView:didSelectedTitlBtn:)]) {
        [self.delegate titleSliderView:self didSelectedTitlBtn:btn];
    }
}


-(void)setModel:(AETitleViewModel *)model{
    if (model == nil)return;
    _model = model;
    //清空旧数据
    for (UIButton *btn in self.subviews) {
        [btn removeFromSuperview];
    }
    
    //颜色
    UIColor *selectedColor = model.sliderColor ? model.sliderColor : RGBColor(0,175,237);
    //创建标图按钮
    CGFloat y = 0;
    CGFloat w = _model.showWidth / _model.titles.count;
    CGFloat h = _model.showWidth * _model.btnHeightScale;
    CGFloat x = 0;
    for (int i = 0; i < _model.titles.count; i++) {
        x = w * i;
        UIButton *btn = [[UIButton alloc] init];
        if (i == 0) {
            self.selectedBtn  = btn;
        }
        btn.tag = i;
        btn.frame = CGRectMake(x, y, w, h);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(titleBtnClick1:) forControlEvents:UIControlEventTouchDown];
        NSString *title = _model.titles[i];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor: selectedColor forState:UIControlStateSelected];
        if(model.bjColor){
            [btn setBackgroundImage:[UIImage imageWithColor:model.bjColor size:btn.bounds.size] forState:UIControlStateNormal];
        }
        if(model.selectedBjColor){
            [btn setBackgroundImage:[UIImage imageWithColor:model.selectedBjColor size:btn.bounds.size] forState:UIControlStateSelected];
        }
        

        //画分割线 第一个不画
        if(!model.hiddenPartingLine && i){
            CALayer *leftLine = [CALayer layer];
            leftLine.frame = CGRectMake(0, h * 0.2, 1, h * 0.6);
            leftLine.backgroundColor = [UIColor grayColor].CGColor;
            [btn.layer addSublayer:leftLine];

        }
        

        [self addSubview:btn];
    }
    
    
    //设置分割线
    CGFloat lineH = 1;
    UIButton *line = [[UIButton alloc] initWithFrame:CGRectMake(0, h, _model.showWidth, lineH)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:line];
    self.line = line;
    
    //设置滑块
    CGFloat sliderW = w * 0.7;
    CGFloat sliderH = 2;
    UIButton *slider = [[UIButton alloc] init];
    slider.backgroundColor = selectedColor;
    slider.bounds = CGRectMake(0, 0, sliderW, sliderH);
    self.slider = slider;
    [self addSubview:slider];
    
    self.frame = self.frame;
   
}

- (void)layoutSubviews{

    self.slider.center = CGPointMake(self.selectedBtn.center.x, CGRectGetMaxY(self.line.frame) - self.slider.frame.size.height * 0.5);
}

- (void)setFrame:(CGRect)frame{
    
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat w = _model.showWidth;
    CGFloat h = w * _model.btnHeightScale + 1;
    frame = CGRectMake(x, y, w, h);
    
    [super setFrame:frame];
}


@end






