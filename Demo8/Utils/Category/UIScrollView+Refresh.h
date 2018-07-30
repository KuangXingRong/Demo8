//
//  UIScrollView+Refresh.h
//  HeaderRefresh
//
//  Created by ios on 2018/1/7.
//  Copyright © 2018年 LZQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef enum : NSUInteger {
    RefreshHideTypeHeader,
    RefreshHideTypeFooter,
    RefreshHideTypeAll,
} RefreshHideType;

@protocol ConfigRefreshDelegate
- (void)headerRefresh:(UIView *)view;
- (void)footerRefresh:(UIView *)view;
@end

@interface UIScrollView (Refresh)

@property(nonatomic, weak)id<ConfigRefreshDelegate> configRefreshDelegate;

@property(nonatomic, assign)BOOL headerRefresh;
@property(nonatomic, assign)BOOL footerRefresh;
@property(nonatomic, assign)BOOL footerEnding;
@property(nonatomic, assign)RefreshHideType hideType;
@property(nonatomic, assign)NSInteger demandPage;
@property(nonatomic, assign)NSInteger totalPages;

@end
