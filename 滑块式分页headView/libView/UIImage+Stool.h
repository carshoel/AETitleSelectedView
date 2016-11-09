//
//  UIImage+Stool.h
//
//  Created by carshoel on 15/12/27.
//  Copyright (c) 2015年 carshoel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Stool)

//拉伸
+ (UIImage *)resizeImageWithName:(NSString *)name;
+ (UIImage *)resizeImageWithName:(NSString *)name left:(float)left top:(float)top;

//裁圆
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (instancetype)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

//颜色图片
/**
 *  根据颜色返回一张可拉伸的图片
 */
+ (instancetype)imageWithColor:(UIColor *)color;
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)resizeImageWithLeft:(float)left top:(float)top;

/**
 *  修改矢量图颜色
 *
 *  maskColor 修改颜色
 */
- (UIImage *)imageMaskWithColor:(UIColor *)maskColor;

/**
 *  获得某个像素的颜色
 *
 *  @param point 像素点的位置
 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point;

/**
 *  获得带颜色的气泡图(可拉伸)
 *
 *  @param titelColor 气泡图颜色
 */
+ (UIImage *)chatImageWithColor:(UIColor *)titelColor;

/**
 *  根据 字符串 和 尺寸 返回一张二维码图片
 *
 *  @param str 字符串
 *  @param size 尺寸
 */
+ (UIImage *)QRcodeImageWithStr:(NSString *)str size:(CGFloat)size;

/**
 *  图片识别二维码
 *  返回识别到的二维码
 */
+ (NSString *)scanQRCode:(UIImage *)image;

@end
