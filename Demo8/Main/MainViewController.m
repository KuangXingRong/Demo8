//
//  MainViewController.m
//  Dome
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "MainViewController.h"
#import "MainNavigationController.h"
#import "BaseViewController.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@property(nonatomic,strong) NSArray<UIViewController*> *array;
@property(nonatomic,strong) NSArray<MainNavigationController*> *vcArray;


@end

@implementation MainViewController

-(instancetype)init{
    if (self = [super init]) {
        self.delegate = self;
        self.vcArray =  @[[[MainNavigationController alloc] initWithRootViewController:[[BaseViewController alloc]init]],
                        [[MainNavigationController alloc] initWithRootViewController:[[BaseViewController alloc]init]]];
    
        
        NSArray *iconNormalArray = @[@"project", @"task", @"privatemessage", @"me"];
        NSArray *titleArray = @[@"学吧", @"我的"];
        
     
        for (int i = 0; i < _vcArray.count; i++) {
            UIViewController *vc = _vcArray[i];
            NSString *iconNormal = [NSString stringWithFormat:@"%@_normal", iconNormalArray[i]];
            NSString *iconSelected = [NSString stringWithFormat:@"%@_selected", iconNormalArray[i]];
          
            vc.tabBarItem.tag = 100 + i;
            // 图标
            vc.tabBarItem.image = [[UIImage imageNamed:iconNormal]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:iconSelected]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.title = titleArray[i];
        }
        self.viewControllers = _vcArray;
        self.tabBar.translucent = NO;
    }
    
    return self;
}



-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    for (int i = 0; i < _vcArray.count; i++) {
        UIViewController *vc = _vcArray[i];
        // 设置标题样式
        NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x76808E], NSFontAttributeName: FONT(12)};
        [vc.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        // 选中的样式
        NSDictionary *selectedAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0xFF0000], NSFontAttributeName: FONT(14)};
        [vc.tabBarItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    }
}




-(BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}
@end
