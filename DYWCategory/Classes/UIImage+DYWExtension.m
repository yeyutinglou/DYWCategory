

#import "UIImage+DYWExtension.h"
#import <AVFoundation/AVFoundation.h>
@implementation UIImage (DYWExtension)


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  根据颜色值生成一张图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}


+ (UIImage *)thumbWithImage:(UIImage *)image scale:(CGFloat)scale
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        
        
        CGSize oldsize = image.size;
        CGSize asize = CGSizeMake(oldsize.width*scale, oldsize.height*scale);
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (UIImage *)videoThumbImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}



+ (void)drawImage:(UIImage *)image rect:(CGRect)rect isSender:(BOOL)isSender
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    //左上弧度角
    CGPoint leftTopCornerTopPoint  = CGPointMake(KMargin+KCornRadius, KMargin);
    CGPoint leftTopCornerBottomPoint = CGPointMake(KMargin, KMargin+KCornRadius);
    
    
    //右上弧度角
    CGPoint rightTopCornerTopPoint  = CGPointMake(width-KCornRadius-KMargin, leftTopCornerTopPoint.y);
    CGPoint rightTopCornerBottomPoint = CGPointMake(width-KMargin,leftTopCornerBottomPoint.y);
    
    
    
    //左下弧度角
    CGPoint leftBottomCornerTopPoint  = CGPointMake(leftTopCornerBottomPoint.x, height-KMargin-KCornRadius);
    CGPoint leftBottomCornerBottomPoint = CGPointMake(leftTopCornerTopPoint.x, height-KMargin);
    
    
    //右下弧度角
    CGPoint rightBottomCornerTopPoint  = CGPointMake(rightTopCornerBottomPoint.x, leftBottomCornerTopPoint.y);
    CGPoint rightBottomCornerBottomPoint = CGPointMake(rightTopCornerTopPoint.x, leftTopCornerBottomPoint.y);
    
    if (isSender) {
        
        //右上尖嘴符号：三角
        //三角上端点
        CGPoint triangleTopPoint = CGPointMake(rightTopCornerBottomPoint.x, rightTopCornerTopPoint.y+KTriangleSpace);
        CGPoint triangleMiddlePoint = CGPointMake(width, triangleTopPoint.y+KTriangleWidth/2);
        CGPoint trianglBottomPoint = CGPointMake(triangleTopPoint.x, triangleTopPoint.y+KTriangleWidth);
        
        
        //先画左上圆弧
        
        [path moveToPoint:leftTopCornerBottomPoint];
        [path addArcWithCenter:CGPointMake(leftTopCornerTopPoint.x, leftTopCornerBottomPoint.y) radius:KCornRadius startAngle:-M_PI endAngle:-M_PI_2 clockwise:YES];
        
        
        //上边框线
        [path addLineToPoint:rightTopCornerTopPoint];
        
        //右上圆弧
        [path addArcWithCenter:CGPointMake(rightTopCornerTopPoint.x, rightTopCornerBottomPoint.y) radius:KCornRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        
        //气泡尖嘴
        [path addLineToPoint:triangleTopPoint];
        [path addLineToPoint:triangleMiddlePoint];
        [path addLineToPoint:trianglBottomPoint];
        
        
        //右边框线
        [path addLineToPoint:rightBottomCornerTopPoint];
        
        
        //右下圆弧
        [path addArcWithCenter:CGPointMake(rightBottomCornerBottomPoint.x, rightBottomCornerTopPoint.y) radius:KCornRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        
        //下边框线
        [path addLineToPoint:leftBottomCornerBottomPoint];
        
        
        [path addArcWithCenter:CGPointMake(leftBottomCornerBottomPoint.x, leftBottomCornerTopPoint.y) radius:KCornRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        
    } else {
        //左上尖嘴符号：三角
        //三角上端点
        CGPoint triangleTopPoint = CGPointMake(leftTopCornerBottomPoint.x, leftTopCornerTopPoint.y+KTriangleSpace);
        CGPoint triangleMiddlePoint = CGPointMake(0, triangleTopPoint.y+KTriangleWidth/2);
        CGPoint trianglBottomPoint = CGPointMake(triangleTopPoint.x, triangleTopPoint.y+KTriangleWidth);
        
        
        //先画左上圆弧
        
        [path moveToPoint:leftTopCornerBottomPoint];
        [path addArcWithCenter:CGPointMake(leftTopCornerTopPoint.x, leftTopCornerBottomPoint.y) radius:KCornRadius startAngle:-M_PI endAngle:-M_PI_2 clockwise:YES];
        
        
        //上边框线
        [path addLineToPoint:rightTopCornerTopPoint];
        
        //右上圆弧
        [path addArcWithCenter:CGPointMake(rightTopCornerTopPoint.x, rightTopCornerBottomPoint.y) radius:KCornRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        
        
        
        //右边框线
        [path addLineToPoint:rightBottomCornerTopPoint];
        
        
        //右下圆弧
        [path addArcWithCenter:CGPointMake(rightBottomCornerBottomPoint.x, rightBottomCornerTopPoint.y) radius:KCornRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        
        //下边框线
        [path addLineToPoint:leftBottomCornerBottomPoint];
        
        
        [path addArcWithCenter:CGPointMake(leftBottomCornerBottomPoint.x, leftBottomCornerTopPoint.y) radius:KCornRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        
        
        //气泡尖嘴
        [path addLineToPoint:triangleTopPoint];
        [path addLineToPoint:triangleMiddlePoint];
        [path addLineToPoint:trianglBottomPoint];
        
    }
    
    //终于画完了,oh shit
    
    [path addClip];
    
    [image drawInRect:rect];
    
}


+ (UIImage *)addImage:(UIImage *)image addMsakImage:(UIImage *)maskImage maskRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    [maskImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


///截图
+ (UIImage *)captureWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    // IOS7及其后续版本
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    } else { // IOS7之前的版本
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
    
}

//可定制截图区域
+ (UIImage *)getImageWithSize:(CGRect)myImageRect FromImage:(UIImage *)bigImage
{
    //大图bigImage
    //定义myImageRect，截图的区域
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = CGRectGetWidth(myImageRect);
    size.height = CGRectGetHeight(myImageRect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}


+ (UIImage *)thumbImage:(UIImage *)image toRect:(CGSize)size
{
    //被切图片宽比例比高比例小 或者相等，以图片宽进行放大
    if (image.size.width*size.height <= image.size.height*size.width) {
        
        //以被剪裁图片的宽度为基准，得到剪切范围的大小
        CGFloat width  = image.size.width;
        CGFloat height = image.size.width * size.height / size.width;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        UIImage *clipImage =  [self imageFromImage:image inRect:CGRectMake(0, (image.size.height -height)/2, width, height)];
        return [self scaleToImage:clipImage Width:size];
        
    }else{ //被切图片宽比例比高比例大，以图片高进行剪裁
        
        // 以被剪切图片的高度为基准，得到剪切范围的大小
        CGFloat width  = image.size.height * size.width / size.height;
        CGFloat height = image.size.height;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        UIImage *clipImage =  [self imageFromImage:image inRect:CGRectMake((image.size.width -width)/2, 0, width, height)];
        return  [self scaleToImage:clipImage Width:size];
    }
    return nil;
    
}

+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

+ (UIImage *)scaleToImage:(UIImage *)image Width:(CGSize)size{
    
    // 如果传入的宽度比当前宽度还要大,就直接返回
    
    
    if (size.width > image.size.width) {
        return  image;
    }
    
    //    // 计算缩放之后的高度
    //    CGFloat height = (size.width / image.size.width) * image.size.height;
    
    // 初始化要画的大小
    CGRect  rect = CGRectMake(0, 0, size.width, size.height);
    
    //清晰图提升
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, [UIScreen mainScreen].scale);
    
    // 1. 开启图形上下文
    //    UIGraphicsBeginImageContext(rect.size);
    
    // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
    [image drawInRect:rect];
    
    // 3. 取到图片
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    // 5. 返回
    return newImage;
}


/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



@end
