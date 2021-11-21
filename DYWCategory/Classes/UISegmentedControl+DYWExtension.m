

#import "UISegmentedControl+DYWExtension.h"
#import "UIImage+DYWExtension.h"

@implementation UISegmentedControl (DYWExtension)

- (void)ensureiOS12Style:(UIColor *)color {
    if (@available(iOS 13, *)) {
        self.backgroundColor = UIColor.whiteColor;
        [self setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        self.selectedSegmentTintColor = color;
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateNormal];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.whiteColor} forState:UIControlStateSelected];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = color.CGColor;
    } else {
        self.tintColor = color;
    }
}

@end
