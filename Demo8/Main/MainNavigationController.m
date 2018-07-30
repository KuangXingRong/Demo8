//
//  MainNavigationController.m
//  Business
//
//  Created by 莘达科技 on 2018/3/19.
//  Copyright © 2018年 莘达科技. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: FONT(18)};
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = MAINCOLOR;
    self.navigationBar.translucent = false;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count != 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"public_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPrevious)];
        viewController.hidesBottomBarWhenPushed = true;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backToPrevious {
    [self popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (![self.visibleViewController isKindOfClass:[UIAlertController class]]) {//iOS9 UIWebRotatingAlertController
        return [self.visibleViewController supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}
@end
