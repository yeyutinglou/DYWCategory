

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, UIViewBorder) {
    UIViewBorderNone   = 0,
    UIViewBorderLeft   = 1 << 0,
    UIViewBorderRight  = 1 << 1,
    UIViewBorderTop    = 1 << 2,
    UIViewBorderBottom = 1 << 3
};

@interface UIView(DYWBorder)

- (void)addBoard:(UIViewBorder)boarderType borderWidth:(CGFloat)width borderColor:(CGColorRef)color;

@end
