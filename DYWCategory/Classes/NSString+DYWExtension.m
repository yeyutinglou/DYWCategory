

#import "NSString+DYWExtension.h"
#import <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 1024 * 8

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath, size_t dataSize) {
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    CFURLRef fileUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, filePath, kCFURLPOSIXPathStyle, false);
    if (!fileUrl) {
        goto  done;
    }
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, fileUrl);
    if (!readStream) {
        goto done;
    }
    bool isSuccess = CFReadStreamOpen(readStream);
    if (!isSuccess) {
        goto done;
    }
    
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    if (!dataSize) {
        dataSize = FileHashDefaultChunkSizeForReadingData;
    }
    
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t bufffer[dataSize];
        CFIndex readBytesCount = CFReadStreamRead(readStream, bufffer, sizeof((bufffer)));
        if (readBytesCount == -1) {
            break;
        }
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;;
        }
        CC_MD5_Update(&hashObject, bufffer, (CC_LONG)readBytesCount);
    }
    isSuccess = !hasMoreData;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    if (!isSuccess) {
        goto done;
    }
    
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                           (const char *)hash,
                                           kCFStringEncodingUTF8);

done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileUrl) {
        CFRelease(fileUrl);
    }
    return result;
    
}

@implementation NSString (DYWExtension)


- (BOOL)isValid {
    if (!self || self.length == 0) {
        return NO;
    }
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return NO;
    }
    return YES;
}

-(CGSize)sizeWidth{
    return [self sizeWidthFont:[UIFont systemFontOfSize:17] size:CGSizeMake(0, MAXFLOAT)];
}
-(CGSize)sizeWidthFont:(UIFont *)font size:(CGSize )size{
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    size = [self boundingRectWithSize:CGSizeMake(0, size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    return size;
}

-(CGSize)sizeHeight{
    return [self sizeHeightFont:[UIFont systemFontOfSize:17]  size:CGSizeMake(MAXFLOAT, 0)];
}
-(CGSize)sizeHeightFont:(UIFont *)font size:(CGSize )size{
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    size = [self boundingRectWithSize:CGSizeMake(size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

+(NSString *)getFileSizeString:(long long )fileSize{
    NSString *fileSizeStr;
    if(fileSize < 1024){
        fileSizeStr = [NSString stringWithFormat:@"%lld B",fileSize];
    }else if (fileSize < 1024 * 1024) {
        fileSizeStr = [NSString stringWithFormat:@"%.2f K",fileSize / 1024.0];
    }else if (fileSize < 1024 * 1024 * 1024) {
        fileSizeStr = [NSString stringWithFormat:@"%.2f M",fileSize / 1024.0 / 1024.0];
    }
    
    return fileSizeStr;
}


- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}


+ (NSString *)positiveFormat:(NSString *)text{
    
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }else{
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
    }
    return @"";
}

/**
 *  校验电话号码
 */
#pragma mark 校验电话号码
-(BOOL)isValidPhone:(NSString *)strPhone{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:strPhone] == YES)
        || ([regextestcm evaluateWithObject:strPhone] == YES)
        || ([regextestct evaluateWithObject:strPhone] == YES)
        || ([regextestcu evaluateWithObject:strPhone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}


- (NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    dateFormat.dateFormat = format;
    return [dateFormat dateFromString:self];
}

- (NSString *)localFileMD5:(NSString *)path {
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef )path, FileHashDefaultChunkSizeForReadingData);
}

@end
