//
//  BaseViewController.m
//  Dome
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UINavigationControllerDelegate>

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKCOLOR;
    self.hideStatusBar = NO;
    self.hiddenNavigationBar = NO;

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    self.navigationController.navigationBar.barTintColor = MAINCOLOR;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WHITECOLOR, NSFontAttributeName:FONT(18)};
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
}


-(void)setStatusBarColor:(UIColor *)statusBarColor{
    _statusBarColor = statusBarColor;
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = statusBarColor;
    }
}

-(void)setHideStatusBar:(BOOL)hideStatusBar{
    _hideStatusBar = hideStatusBar;
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.alpha = hideStatusBar ? .0f : 1.0f;
}

-(void)setHiddenNavigationBar:(BOOL)hiddenNavigationBar{
    _hiddenNavigationBar = hiddenNavigationBar;
    [self.navigationController setNavigationBarHidden:hiddenNavigationBar animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return UIView.new;
}

//隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL hidden = [viewController isKindOfClass:[self class]] && self.hiddenNavigationBar;
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
}



//当前控制器弹出时的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//当前控制器支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (BOOL)shouldAutorotate{
    return YES;
}
@end
