

#import "UIViewController+DYWExtension.h"
#import <objc/runtime.h>
#import "NSObject+DYWSwizzling.h"

@implementation UIViewController (DYWExtension)

+ (void)load {
    [self DYW_methodSwizlingWithOriginalSelector:@selector(presentViewController:animated:completion:) swizzledSelector:@selector(dyw_presentViewController:animated:completion:)];
}

- (void)dyw_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [self dyw_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)dyw_viewWillAppear:(BOOL)animated {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self dyw_viewWillAppear:animated];
}

@end
