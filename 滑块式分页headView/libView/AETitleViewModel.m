//
//  AETitleViewModel.m
//  AETravel
//
//  Created by carshoel on 16/5/6.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "AETitleViewModel.h"

@implementation AETitleViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titles = @[@"test1",@"test2"];
        self.sliderColor = [UIColor redColor];
        self.separatoryColor = [UIColor grayColor];
        self.showWidth = 300;
        self.btnHeightScale = 1/3.0;
    }
    return self;
}

-(UIButton *)buttonStyle{
    if (!_buttonStyle) {
        _buttonStyle = [[UIButton alloc] init];
    }
    return _buttonStyle;
}

+(instancetype)modelWithTitles:(NSArray *)titles showWidht:(CGFloat)showWidth btnHeightScale:(CGFloat)scale{
    AETitleViewModel *model = [[self alloc] init];
    model.titles = titles;
    model.showWidth = showWidth;
    model.btnHeightScale = scale;
    return model;
}

@end
