//
//  KSlideView.h
//  Dome
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KCarousel.h"
#import "SMPageControl.h"



@protocol KSlideViewDelegate;


@interface KSlideView : KCarousel<KCarouselDelegate>

@property (nonatomic, weak ) id<KSlideViewDelegate> slideViewDelegate;


@property (nonatomic, copy)void(^itemClickBlock)(NSInteger index);      //点击图片事件
@property (nonatomic, copy)void(^scrollOffsetBlock)(CGFloat offset);    //滑动偏移量

@property(nonatomic, assign) BOOL isCycle;              //是否循环
@property(nonatomic, assign) BOOL autoSlide;            //自动轮播
@property(nonatomic, assign) CGFloat autoSlideTime;     //自动轮播时间间隔

@property(nonatomic, assign,readonly) NSInteger currentItemIndex;

@property(nonatomic, assign) BOOL showPageControl;      //是否显示小点
@property(nonatomic, strong) SMPageControl* pageControl;//小点
@end

@protocol KSlideViewDelegate <NSObject>

@optional

- (void)slideView:(KSlideView *)slideView viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view  object:(id) itemData;


@end


@interface UIView(UIView_KSlideView)

- (KSlideView*) addKSlideView:(CGRect) frame;

@end

