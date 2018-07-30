//
//  UIView+Common.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-6.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "UIView+Common.h"
#import "NSString+Common.h"

@implementation UIView (Common)

//@dynamic borderColor,borderWidth,cornerRadius, masksToBounds;

- (ClickBlock)clickBlock {
    return objc_getAssociatedObject(self, @selector(clickBlock));
}

- (void)setClickBlock:(ClickBlock) aclickBlock{
    objc_setAssociatedObject(self, @selector(clickBlock), aclickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = width;
    if (!color) {
        self.layer.borderColor = UIColor.clearColor.CGColor;
    }else{
        self.layer.borderColor = color.CGColor;
    }
}

/**
 *  设置部分圆角
 *
 *  @param position 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param cornerRadius   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */

- (void)addRoundedCorners:(UIRectCorner)position cornerRadius:(CGFloat)cornerRadius  viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:position cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
 
}

/**
 *  设置部分圆角
 *
 *  @param position 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param cornerRadius   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)position  cornerRadius:(CGFloat)cornerRadius{
    
    [self addRoundedCorners:position cornerRadius:cornerRadius viewRect:self.bounds];
}


- (UIViewController *)findViewController
{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

- (void)removeViewWithTag:(NSInteger)tag{
    UIView *view = [self viewWithTag:tag];
    [view removeFromSuperview];
}

-(void)addClick:(nullable id)target selector:(nullable SEL) selctor{
    if ([self isKindOfClass:UIButton.class]) {
        [(UIButton*)self addTarget:target action:selctor forControlEvents:(UIControlEventTouchUpInside)];
    }else{
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:selctor];
        [self setUserInteractionEnabled:YES];  //事UIlablel接受点击事件
        [self addGestureRecognizer:tapGesture];
    }
}

-(void)addClick:(ClickBlock) block{
    self.clickBlock = block;
    if ([self isKindOfClass:UIButton.class]) {
        [(UIButton*)self addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }else{
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
        [self setUserInteractionEnabled:YES];  //事UIlablel接受点击事件
        [self addGestureRecognizer:tapGesture];
    }
}

-(void)viewClick:(UITapGestureRecognizer*) gesture{
    if (self.clickBlock) {
        self.clickBlock(gesture.view);
    }
}

-(void)btnClick:(UIButton*) btn{
    if (self.clickBlock) {
        self.clickBlock(btn);
    }
}

#pragma mark - Create and Add View

-(void)showLine:(DisplayPosition) displayPosition leftSpce:(CGFloat) leftSpce{
    [self showLine:displayPosition leftSpce:leftSpce rightSpce:0];
}

-(void)showLine:(DisplayPosition) displayPosition leftSpce:(CGFloat) leftSpce rightSpce:(CGFloat) rightSpc{
    [self showLine:displayPosition leftSpce:leftSpce rightSpce:rightSpc weight:1.0f];
}


-(void)showLine:(DisplayPosition) displayPosition leftSpce:(CGFloat) leftSpce rightSpce:(CGFloat) rightSpc  weight:(CGFloat)weight{
    
    UIView *bottomLineView = [self viewWithTag:242424];
    UIView *topLineView = [self viewWithTag:121212];
    if ( displayPosition & DisplayPositionBottom ){
        if (!bottomLineView) {
            bottomLineView = UIView.new;
            bottomLineView.tag = 242424;
            bottomLineView.backgroundColor = LINECOLOR;
            [self addSubview:bottomLineView] ;
            [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(leftSpce);
                make.right.mas_offset(-rightSpc);
                make.bottom.mas_offset(0);
                make.height.mas_equalTo(weight);
                
            }];
        }
        
        [bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(leftSpce);
            make.right.mas_offset(-rightSpc);
        }];
    }
    if (displayPosition & DisplayPositionTop){
        if (!topLineView) {
            topLineView = UIView.new;
            topLineView.tag = 121212;
            topLineView.backgroundColor = LINECOLOR;
            [self addSubview:topLineView] ;
            [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(leftSpce);
                make.right.mas_offset(-rightSpc);
                make.top.mas_offset(0);
                make.height.mas_equalTo(weight);
                
            }];
        }
        
        [topLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(leftSpce);
            make.right.mas_offset(-rightSpc);
        }];
    }
    
    if (displayPosition & DisplayPositionNone) {
        [bottomLineView setHidden:YES];
        [topLineView setHidden:YES];
        return;
    }
    
    if (displayPosition & DisplayPositionNOHidden) {
        [bottomLineView setHidden:NO];
        [topLineView setHidden:NO];
    }else{
        [bottomLineView setHidden:!(displayPosition & DisplayPositionBottom)];
        [topLineView setHidden:!(displayPosition & DisplayPositionTop)];
        
    }
    
}



-(UIImageView*) addImg:(CGRect) frame image:(UIImage*) image{
    UIImageView* imageView = [self addImg:frame];
    imageView.image = image;
    return imageView;
}

-(UIImageView*) addImg:(CGRect) frame{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    return imageView;
}

-(UILabel*) addCenterLab:(NSString*)title fontSize:(CGFloat) fontSize color:(UInt32) hexColor width:(float) width{
    UILabel *label = [self addLab:title fontSize:fontSize color:hexColor maxWidth:width];
    label.textAlignment = NSTextAlignmentCenter;
    label.width = width;
    return label;
}

-(UILabel*) addLab:(NSString*)title fontSize:(CGFloat) fontSize color:(UInt32) hexColor maxWidth:(float) maxWidth{

    return [self addLab:title fontSize:fontSize color:hexColor maxWidth:maxWidth lines:1];
}

-(UILabel*) addLab:(NSString*)title fontSize:(CGFloat) fontSize color:(UInt32) hexColor maxWidth:(float) maxWidth  lines:(NSInteger) lines{
    UILabel * label = UILabel.new;
    label.maxWidth = maxWidth;
    label.font = FONT(fontSize);
    label.textColor = [UIColor colorWithRGBHex:hexColor];
    label.numberOfLines = lines;
    [label setString:title];
    [self addSubview:label];
    return label;
}



-(UIButton*)addBtn:(NSString*)title fontSize:(CGFloat) fontSize color:(UInt32) hexColor size:(CGSize) size{
    UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)] ;
    [button setTitleColor:[UIColor colorWithRGBHex:hexColor] forState:UIControlStateNormal];
    button.titleLabel.font = FONT(fontSize);
    [button setSize:size];
    [button setTitle:title forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}

-(UIView*)addViewWithsize:(CGSize) size{
    UIView* lineView = [[UIView alloc] init];
    [lineView setSize:size];
    [self addSubview:lineView];
    return lineView;
}

-(UIView*)addViewWithBGColor:(UInt32) hexColor  size:(CGSize) size{
    UIView* lineView = [[UIView alloc] init];
    [lineView setSize:size];
    lineView.backgroundColor = [UIColor colorWithRGBHex:hexColor];
    [self addSubview:lineView];
    return lineView;
}

static void *borderColorKey = &borderColorKey;
-(void)setBorderColor:(UIColor *)borderColor{
    [self willChangeValueForKey:@"borderColor"]; // KVO
    objc_setAssociatedObject(self, borderColorKey,
                             borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"borderColor"]; // KVO
    self.layer.borderColor = borderColor.CGColor;
}

-(UIColor *)borderColor{
    return objc_getAssociatedObject(self, &borderColorKey);
}



static void *borderWidthKey = &borderWidthKey;
-(void)setBorderWidth:(CGFloat)borderWidth{
    [self willChangeValueForKey:@"borderWidth"]; // KVO
    objc_setAssociatedObject(self, borderWidthKey,
                             [NSNumber numberWithFloat:borderWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"borderWidth"]; // KVO
    
    self.layer.borderWidth = borderWidth;
}
-(CGFloat)borderWidth{
    return [objc_getAssociatedObject(self, borderWidthKey) floatValue];
}


static void *cornerRadiusKey = &cornerRadiusKey;
-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self willChangeValueForKey:@"cornerRadius"]; // KVO
    objc_setAssociatedObject(self, cornerRadiusKey,
                             [NSNumber numberWithFloat:cornerRadius], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"cornerRadius"]; // KVO
    self.layer.cornerRadius = cornerRadius;
}
-(CGFloat)cornerRadius{
    return [objc_getAssociatedObject(self, cornerRadiusKey) floatValue];
}


static void *masksToBoundsKey = &masksToBoundsKey;
-(void)setMasksToBounds:(BOOL)masksToBounds{
    [self willChangeValueForKey:@"masksToBounds"]; // KVO
    objc_setAssociatedObject(self, masksToBoundsKey,
                             [NSNumber numberWithBool:masksToBounds], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"masksToBounds"]; // KVO
    self.layer.masksToBounds = masksToBounds;
}

-(BOOL)masksToBounds{
    return [objc_getAssociatedObject(self, masksToBoundsKey) boolValue];
}

@end


