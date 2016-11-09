//
//  AETitleViewModel.h
//  AETravel
//
//  Created by carshoel on 16/5/6.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AETitleViewModel : NSObject

/*要显示的标题数组*/
@property (nonatomic, strong)NSArray *titles;

//滑块的颜色 和选中标题颜色
@property (nonatomic, strong)UIColor *sliderColor;

//背景色
@property (nonatomic, strong)UIColor *bjColor;

//选中背景色
@property (nonatomic, strong)UIColor *selectedBjColor;

//分割线的颜色
@property (nonatomic, strong)UIColor *separatoryColor;

//标题按钮的样式
@property (nonatomic, strong)UIButton *buttonStyle;

//将要显示的宽度
@property (nonatomic, assign)CGFloat showWidth;
//标题按钮的高宽比
@property (nonatomic, assign)CGFloat btnHeightScale;

//是否隐藏中间分割线
@property (nonatomic, assign)BOOL hiddenPartingLine;

+ (instancetype)modelWithTitles:(NSArray *)titles showWidht:(CGFloat)showWidth btnHeightScale:(CGFloat)scale;

@end
