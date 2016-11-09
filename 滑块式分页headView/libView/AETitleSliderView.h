//
//  AETitleSliderView.h
//  AETravel
//
//  Created by carshoel on 16/5/6.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AETitleViewModel.h"
@class AETitleSliderView;

@protocol AETitleSliderViewDelegate <NSObject>

- (void)titleSliderView:(AETitleSliderView *)titleSliderView didSelectedTitlBtn:(UIButton *)btn;

@end

@interface AETitleSliderView : UIView

@property (nonatomic, strong)AETitleViewModel *model;
@property (nonatomic, weak)id<AETitleSliderViewDelegate> delegate;

@end
