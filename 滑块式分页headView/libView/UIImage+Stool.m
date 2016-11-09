//
//  UIImage+Stool.m
//
//  Created by carshoel on 15/12/27.
//  Copyright (c) 2015年 carshoel. All rights reserved.
//

#import "UIImage+Stool.h"

@implementation UIImage (Stool)

/**返回可拉伸图片*/
+ (UIImage *)resizeImageWithName:(NSString *)name{

    
    return [self resizeImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizeImageWithName:(NSString *)name left:(float)left top:(float)top{
    
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

- (UIImage *)resizeImageWithLeft:(float)left top:(float)top{
    return [self stretchableImageWithLeftCapWidth:self.size.width * left topCapHeight:self.size.height * top];
}


+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
     return [UIImage circleImage:oldImage borderWidth:borderWidth borderColor:borderColor];
}


+ (instancetype)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    
    // 2.开启上下文
    CGFloat imageW = image.size.width + 2 * borderWidth;
    CGFloat imageH = image.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [image drawInRect:CGRectMake(borderWidth, borderWidth, image.size.width, image.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


+(instancetype)imageWithColor:(UIColor *)color{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size{

    //开启上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画图
    [color set];
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    //取图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

/**改变图片颜色*/
- (UIImage *)imageMaskWithColor:(UIColor *)maskColor {
    if (!maskColor) {
        return nil;
    }
    UIImage *newImage = nil;
    CGRect imageRect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -(imageRect.size.height));
    CGContextClipToMask(context, imageRect, self.CGImage);//选中选区 获取不透明区域路径
    CGContextSetFillColorWithColor(context, maskColor.CGColor);//设置颜色
    CGContextFillRect(context, imageRect);//绘制
    newImage = UIGraphicsGetImageFromCurrentImageContext();//提取图片
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  获得某个像素的颜色
 *
 *  @param point 像素点的位置
 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point {
    UIColor *color = nil;
    CGImageRef inImage = self.CGImage;
    CGContextRef contexRef = [self ARGBBitmapContextFromImage:inImage];
    if (contexRef == NULL) return nil;
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(contexRef, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (contexRef);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(contexRef);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

/**
 *  根据CGImageRef来创建一个ARGBBitmapContext
 */
- (CGContextRef)ARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);  //deprecated
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}


//画气泡图片
+ (UIImage *)chatImageWithColor:(UIColor *)titelColor{
    
    CGFloat topW = 6;
    CGFloat topH = 12;
    CGFloat H = 38;//标题栏的高度
    CGFloat R = 3;//圆角
    CGFloat C = 5;
    //    UIColor *titelColor = [UIColor orangeColor];
    
    CGFloat ImgW = 50;
    CGFloat ImgH = 80;
    
    //开启图形上下午
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ImgW, ImgH), NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画图
    CGContextSetLineWidth(ctx, 0.5);
    [titelColor set];
    //左上圆弧
    CGContextAddArc(ctx, topW + R, R, R, -M_PI * 0.5, -M_PI, 1);
    //线条
    CGContextAddLineToPoint(ctx, topW, (H - topH) * 0.5);
    CGContextAddLineToPoint(ctx, 0, H * 0.5);
    CGContextAddLineToPoint(ctx, topW, H * 0.5 + topH * 0.5);
    CGContextAddLineToPoint(ctx, topW, H);
    CGContextAddLineToPoint(ctx, ImgW, H);
    CGContextAddLineToPoint(ctx, ImgW, R);
    //    //右上圆弧
    CGContextAddArc(ctx, ImgW - R, R, R, 0, -M_PI * 0.5, 1);
    CGContextClosePath(ctx);
    
    //    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
    
    
    topW += 0.25;
    [[UIColor whiteColor] set];
    //画下半身
    CGContextMoveToPoint(ctx, topW, H);
    CGContextAddLineToPoint(ctx, topW, ImgH - R);
    //左下圆
    CGContextAddArc(ctx, topW + R, ImgH - R, R, -M_PI, -M_PI * 1.5, 1);
    CGContextAddLineToPoint(ctx, ImgW - R, ImgH);
    //右小圆
    CGContextAddArc(ctx, ImgW - R, ImgH - R, R, -M_PI * 1.5, -M_PI * 2, 1);
    CGContextAddLineToPoint(ctx, ImgW, H);
    CGContextClosePath(ctx);
    //    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
    
    //取图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  根据 字符串 和 尺寸 返回一张二维码图片
 *
 *  @param str 字符串
 *  @param size 尺寸
 */
+ (UIImage *)QRcodeImageWithStr:(NSString *)str size:(CGFloat)size{

    if(!str)return nil;
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    // 3.将字符串转换成NSdata
    
    NSData *data  = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4.1通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    //4.2设置 filter 容错等级
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    
    //UIImage *image = [UIImage  imageWithCIImage:outputImage];
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    
    // 6.设置生成好得二维码到imageview上
    return image;
    

}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 *  图片识别二维码
 *  返回识别到的二维码
 */
+ (NSString *)scanQRCode:(UIImage *)image{
    
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int i = 0; i < (int)features.count; i++) {
        CIQRCodeFeature *feature = [features objectAtIndex:i];
        NSString *scannedResult = feature.messageString;
        NSLog(@"scanQRCode ---->result:%@",scannedResult);
        if(scannedResult.length)return scannedResult;
    }
    return nil;
}



@end
