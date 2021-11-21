

#import "UINavigationController+DYWExtension.h"
#import <objc/runtime.h>
#import "NSObject+DYWSwizzling.h"


@implementation UINavigationController (DYWExtension)

+ (void)load {
    [self DYW_methodSwizlingWithOriginalSelector:@selector(pushViewController:animated:) swizzledSelector:@selector(dyw_pushViewController:animated:)];
}

- (void)dyw_pushViewController:(UIViewController <UIGestureRecognizerDelegate> *)viewController animated:(BOOL) animated {
     __weak typeof(self) weakSelf = self;
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        if (self.viewControllers.count > 0) {
            if ([self.viewControllers.lastObject isKindOfClass:[viewController class]]) {
                return;
            }
    //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [btn addTarget:self action:@selector(didBack) forControlEvents:UIControlEventTouchUpInside];
    //        [btn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    //        [btn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateHighlighted];
    //        btn.size = btn.currentImage.size;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(didBack)];
        
    }
    [self dyw_pushViewController:viewController animated:animated];
}

- (void)didBack {
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}

@end
