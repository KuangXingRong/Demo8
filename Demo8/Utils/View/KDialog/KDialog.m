//
//  KDialog.m
//  Dome
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KDialog.h"


@interface KDialog()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIView* rootView;
@property(nonatomic, copy)void(^hiddenBlock)(void);

@end
@implementation KDialog


-(instancetype)init{
    if (self = [super init]) {
        
        self.rootView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        self.rootView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rootViewClick)];
        recognizer.delegate = self;
        [self.rootView addGestureRecognizer:recognizer];
      
    }
    return self;
}

-(void)show{
    [self.rootView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.rootView];
    
    if (self.rootView.subviews.count == 0) {
        [self.delegate dialog:self addSubviewToRootView:self.rootView];
    }
    
    if ([self.delegate respondsToSelector:@selector(dialog:animationOnRootView:isShow:)]) {
        [self.delegate dialog:self animationOnRootView:self.rootView isShow:YES];
    }
}

-(void)dismiss{
    if ([self.delegate respondsToSelector:@selector(dialog:animationOnRootView:isShow:)]) {
       [self.delegate dialog:self animationOnRootView:self.rootView isShow:NO];
    }else{
        [self.rootView removeFromSuperview];
    }
}

#pragma mark - 点击空白处关闭
-(void)rootViewClick{
    [self dismiss];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return touch.view == self.rootView;
}
@end
