//
//  UIView+Common.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-6.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"

#define PD(top, left, bottom, right) UIEdgeInsetsMake(top, left, bottom, right)
#define Frame(x, y, width, height) CGRectMake(x, y, width, height)
#define GetFontHeight(font) [@"我" getHeightWithFont:font constrainedToSize:CGSizeMake(1000, CGFLOAT_MAX)]
#define RedImage(width, height) [UIImage imageWithColor:UIColor.redColor withFrame:Frame(0, 0, width, height)]
#define BlueImage(width, height) [UIImage imageWithColor:UIColor.blueColor withFrame:Frame(0, 0, width, height)]
#define WhiteImage(width, height) [UIImage imageWithColor:UIColor.whiteColor withFrame:Frame(0, 0, width, height)]

typedef NS_OPTIONS(NSUInteger, DisplayPosition) {
    DisplayPositionNone = 1 << 0,
    DisplayPositionTop = 1 << 1,
    DisplayPositionBottom = 1 << 2,
    DisplayPositionNOHidden = 1 << 3
};

typedef void (^ClickBlock)(id view);

IB_DESIGNABLE
@interface UIView (Common)
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL masksToBounds;


@property (nonatomic, copy) ClickBlock clickBlock;

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

- (void)addRoundedCorners:(UIRectCorner)position  cornerRadius:(CGFloat)cornerRadius;

- (void)addRoundedCorners:(UIRectCorner)position cornerRadius:(CGFloat)cornerRadius  viewRect:(CGRect)rect;


- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setOrigin:(CGPoint)origin;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setSize:(CGSize)size;

-(void)addClick:(nullable id)target selector:(nullable SEL) selctor;
-(void)addClick:(void(^)(id view)) block;

- (UIViewController *)findViewController;
- (void)removeViewWithTag:(NSInteger)tag;

#pragma mark - Create and Add View
-(void)showLine:(DisplayPosition) displayPosition leftSpce:(CGFloat) leftSpce;
-(void)showLine:(DisplayPosition) displayPosition leftSpce:(CGFloat) leftSpce rightSpce:(CGFloat) rightSpce;
-(void)showLine:(DisplayPosition) displayPosition leftSpce:(CGFloat) leftSpce rightSpce:(CGFloat) rightSpce weight:(CGFloat)weight;



-(UIImageView*) addImg:(CGRect) frame image:(UIImage*) image;
-(UIImageView*) addImg:(CGRect) frame;

-(UILabel*) addCenterLab:(NSString*)title fontSize:(CGFloat) fontSize color:(UInt32) hexColor width:(float) width;
-(UILabel*) addLab:(NSString*)title fontSize:(CGFloat) fontSize color:(UInt32) hexColor maxWidth:(float) maxWidth;
-(UILabel*) addLab:(NSString*)title fontSize:(CGFloat) fontSize color:(UInt32) hexColor maxWidth:(float) maxWidth  lines:(NSInteger) lines;

-(UIButton*)addBtn:(NSString*)title fontSize:(CGFloat) fontSize color:(UInt32) hexColor size:(CGSize) size;

-(UIView*)addViewWithBGColor:(UInt32) hexColor  size:(CGSize) size;
-(UIView*)addViewWithsize:(CGSize) size;
@end

