//
//  BaseViewController.h
//  Dome
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


//是否隐藏状态栏
@property(nonatomic, assign)BOOL hideStatusBar;

//状态栏背景颜色
@property(nonatomic, strong)UIColor *statusBarColor;

//是否隐藏导航栏
@property(nonatomic, assign)BOOL hiddenNavigationBar;


@end
