//
//  UISearchBar+Common.h
//  Coding_iOS
//
//  Created by Ease on 15/4/22.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (Common)

- (UITextField *)eaTextField;
- (void)setPlaceholderColor:(UIColor *)color;
-(void)textFieldContentCenter:(BOOL) center;

- (void)setSearchIcon:(UIImage *)image;
- (void)setSearchIconSpace:(CGFloat) space;

- (void)setRightBtnIcon:(UIImage *)image;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
@end
