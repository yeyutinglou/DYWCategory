

#import "UIColor+DYWExtension.h"

@implementation UIColor (DYWExtension)

+ (UIColor *)colorWithHex:(long)hex {
    return [UIColor colorWithHex:hex alpha:1.0f];
}


+ (UIColor *)colorWithHex:(long)hex alpha:(float)alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

@end
