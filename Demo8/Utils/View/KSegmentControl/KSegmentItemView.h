//
//  KSegmentItemView.h
//  Dome
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSegmentItemView : UICollectionViewCell

@property (nonatomic, assign)BOOL propertyInit; //是否初始化了属性

//image property
@property (nonatomic, assign)CGSize imgSize;    //图片尺寸
@property (nonatomic, assign)BOOL cornerImage;  //是否是圆图

//title property
@property (nonatomic, assign)CGFloat titleMarginTop;      //标题与上方的边距
@property (nonatomic, strong)UIFont*  titleFont;    //标题字体
@property (nonatomic, strong)UIColor* titleColor;   //标题颜色

@property (strong, nonatomic)  UIImageView *imgIcon;
@property(nonatomic, strong) UILabel *labTitle;

@end
