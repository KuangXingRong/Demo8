//
//  KPlayerView.h
//  Demo7
//  全屏
//  播放暂停快进,自动隐藏
//  加载处理
//  手势
//  代理
//  Created by apple on 2018/7/22.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KPlayerViewDelegate;

@interface KPlayerView : UIView

@property(nonatomic,weak)id<KPlayerViewDelegate> delegate;
 
- (void)playWithURL:(NSURL *) url;

@end

@protocol KPlayerViewDelegate <NSObject>

@optional

-(void)playerView:(KPlayerView*) playerView addSubviewTBottomTool:(UIView*)bottomTool;

-(void)playerView:(KPlayerView*) playerView resetFrame:(BOOL) fullScreen;

@end


@interface UIView(UIView_KPlayerView)

- (KPlayerView*) addKPlayerView:(CGRect) frame;

@end

