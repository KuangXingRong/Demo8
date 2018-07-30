//
//  KDialog.h
//  Dome
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol KDialogDelegate;

@interface KDialog : NSObject

@property(nonatomic,weak)id<KDialogDelegate> delegate;


-(void)show;

-(void)dismiss;

@end


@protocol KDialogDelegate <NSObject>

-(void)dialog:(KDialog*) dialog addSubviewToRootView:(UIView*)rootView;

@optional

-(void)dialog:(KDialog*) dialog animationOnRootView:(UIView*) rootView  isShow:(BOOL) isShow;

@end
