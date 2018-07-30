//
//  UIButton+Common.m
//  Dome
//
//  Created by apple on 2018/6/16.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton(Common)

//自适应宽高
- (void)setString:(NSString *)str forState:(UIControlState)state{
    [self setTitle:str forState:state];
    CGSize resultSize = [str getSizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(1000, CGFLOAT_MAX)];
    CGSize size  = CGSizeMake(resultSize.width + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
                            resultSize.height + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
    
    [self setSize:size];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state padding:(UIEdgeInsets) padding{
    [self setImage:image forState:state];
    [self setImageEdgeInsets:padding];
}
@end
