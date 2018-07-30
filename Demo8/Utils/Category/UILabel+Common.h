//
//  UILabel+Common.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-8.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

@property (readwrite, nonatomic, assign, setter = setMaxWidth:) float maxWidth;


- (void) setString:(NSString *)str;

- (void)setAttrStrWithStr:(NSString *)text diffColorStr:(NSString *)diffColorStr diffColor:(UIColor *)diffColor;
- (void)addAttrDict:(NSDictionary *)attrDict toStr:(NSString *)str;
- (void)addAttrDict:(NSDictionary *)attrDict toRange:(NSRange)range;

- (void)colorTextWithColor:(UIColor *)color range:(NSRange)range;
- (void)fontTextWithFont:(UIFont *)font range:(NSRange)range;


@end
