

#import "UIViewController+DYWChild.h"

@implementation UIViewController (DYWChild)


-(void)displayViewController:(UIViewController *)viewController view:(UIView *)view
{
    [self addChildViewController:viewController];
    viewController.view.frame = view.bounds;
    [view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

-(void)showBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
