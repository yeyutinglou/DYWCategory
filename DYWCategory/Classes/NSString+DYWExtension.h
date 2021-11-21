

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (DYWExtension)


/// 字符串是否合法
- (BOOL) isValid;

/**
 *  计算文字宽度
 */
-(CGSize)sizeWidth;
-(CGSize)sizeWidthFont:(UIFont *)font size:(CGSize )size;

/**
 *  计算文字高度
 */
-(CGSize)sizeHeight;
-(CGSize)sizeHeightFont:(UIFont *)font size:(CGSize )size;

/**
 *  文件大小数字装换
 *
 *  @param fileSize 入参大小:1024
 *
 *  @return 出参大小:1M
 */
+ (NSString *)getFileSizeString:(long long )fileSize;

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;

+ (NSString *)positiveFormat:(NSString *)text;

/**
 *  校验电话号码
 */
-(BOOL)isValidPhone:(NSString *)strPhone;


/// md5
- (NSString *)md5;


/// 字符串转日期
/// @param format 日期格式
- (NSDate *)dateWithFormat:(NSString *)format;


/// 沙盒里文件MD5
/// @param path 路径
- (NSString *)localFileMD5:(NSString *)path;



@end
