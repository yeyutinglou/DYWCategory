

#import "UIView+DYWBorder.h"

@implementation UIView(DYWBorder)

- (void)addBoard:(UIViewBorder)boarderType borderWidth:(CGFloat)width borderColor:(CGColorRef)color{

    if (boarderType & UIViewBorderLeft) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = color;
        border.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.frame));
        [self.layer addSublayer:border];
    }
    
    if (boarderType & UIViewBorderRight) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = color;
        border.frame = CGRectMake(CGRectGetWidth(self.frame)-width, 0, width, CGRectGetHeight(self.frame));
        [self.layer addSublayer:border];
    }
    
    if (boarderType & UIViewBorderTop) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = color;
        border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), width);
        [self.layer addSublayer:border];
    }
    
    if (boarderType & UIViewBorderBottom) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = color;
        border.frame = CGRectMake(0, CGRectGetHeight(self.frame)-width, CGRectGetWidth(self.frame), width);
        [self.layer addSublayer:border];
    }
}

@end
