//
//  UIButton+Common.h
//  Dome
//
//  Created by apple on 2018/6/16.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(Common)

//自适应宽高
- (void) setString:(NSString *)str forState:(UIControlState)state;

-(void)setImage:(UIImage *)image forState:(UIControlState)state;
@end
