//
//  UILabel+Common.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-8.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "UILabel+Common.h"
#import "NSString+Common.h"

@implementation UILabel (Common) 



- (float)maxWidth {
    return [(NSNumber*)objc_getAssociatedObject(self, @selector(maxWidth)) floatValue];
}

- (void)setMaxWidth:(float) amaxWidth{
    objc_setAssociatedObject(self, @selector(maxWidth), [NSNumber numberWithFloat:amaxWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)resize{
    
    self.size = CGSizeMake(self.maxWidth, 0);
    [self sizeToFit];
    if (self.width > self.maxWidth) {
        self.width = self.maxWidth;
    }
}

- (void)setString:(NSString *)text{
    self.text = text;
    [self resize];
}


- (void)setAttrStrWithStr:(NSString *)text diffColorStr:(NSString *)diffColorStr diffColor:(UIColor *)diffColor{
    
    NSMutableAttributedString *attrStr;
    if (text) {
        attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    }
    if (diffColorStr && diffColor) {
        NSRange diffColorRange = [text rangeOfString:diffColorStr];
        if (diffColorRange.location != NSNotFound) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:diffColor range:diffColorRange];
        }
    }
    self.attributedText = attrStr;
    [self resize];
}
- (void)addAttrDict:(NSDictionary *)attrDict toStr:(NSString *)str{
    if (str.length <= 0) {
        return;
    }
    NSMutableAttributedString *attrStr = self.attributedText? self.attributedText.mutableCopy: [[NSMutableAttributedString alloc] initWithString:self.text];
    [self addAttrDict:attrDict toRange:[attrStr.string rangeOfString:str]];
}

- (void)addAttrDict:(NSDictionary *)attrDict toRange:(NSRange)range{
    if (range.location == NSNotFound || range.length <= 0) {
        return;
    }
    NSMutableAttributedString *attrStr = self.attributedText? self.attributedText.mutableCopy: [[NSMutableAttributedString alloc] initWithString:self.text];
    if (range.location + range.length > attrStr.string.length) {
        return;
    }
    [attrStr addAttributes:attrDict range:range];
    self.attributedText = attrStr;
    [self resize];
}



- (void)colorTextWithColor:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *attrStr = self.attributedText? self.attributedText.mutableCopy: [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attrStr;
    [self resize];
}

- (void)fontTextWithFont:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *attrStr = self.attributedText? self.attributedText.mutableCopy: [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [attrStr addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = attrStr;
    [self resize];
}


@end
