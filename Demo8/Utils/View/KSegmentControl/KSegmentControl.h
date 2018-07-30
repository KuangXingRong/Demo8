//
//  KSegmentControl.h
//  Dome
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <UIKit/UIKit.h>



//显示的元素
typedef NS_OPTIONS(NSUInteger, DisplayOption) {
    DisplayOptionTitle = 1 << 0, //default 标题
    DisplayOptionImage = 1 << 1, // 图片
    DisplayOptionLineView = 1 << 2 // 下划线
};


@interface KSegmentControl : UICollectionView


//image property
@property (nonatomic, assign)CGSize imgSize;    //图片尺寸
@property (nonatomic, assign)BOOL cornerImage;  //是否是圆图

//title property
@property (nonatomic, assign)CGFloat titleMarginTop;      //标题与上方的边距
@property (nonatomic, strong)UIFont*  titleFont;    //标题字体
@property (nonatomic, strong)UIColor* titleColor;   //标题颜色
@property (nonatomic, strong)UIFont*  titleSelectedFont;    //标题选中时字体
@property (nonatomic, strong)UIColor* titleSelectedColor;   //标题选中时颜色
@property (nonatomic, assign)CGSize titleSize;    //标题尺寸

//lineView property
@property (nonatomic, assign)BOOL lineViewWidthAuto;                //yes表示下划线宽度与title宽度一样
@property (nonatomic, assign)CGSize lineViewSize;                   //下划线尺寸
@property (nonatomic, assign)NSInteger  lineViewDefaultSelectIndex; //下划线默认选中位置
@property (nonatomic, assign)UIEdgeInsets lineViewPadding;          //下划线边距(MarginTop、MarginBottom、 paddingLeft、paddingRight)
@property (nonatomic, strong)UIColor* lineViewColor;                //下划线颜色

//Self property
//数据源  @[@{@"title":@"tab", @"imgURL":@"http://www.vvv.2233.png"}, ...]
@property (nonatomic, strong) NSArray<NSDictionary*>* arrayData;
@property (nonatomic, copy)void(^itemSelectedBlock)(NSInteger position);   //点击事件
@property (nonatomic, assign) DisplayOption displayOption;
@property (nonatomic, assign)NSInteger itemSpacing;         //每个item的间距
@property (nonatomic, assign, readonly)NSInteger selectedItemIndex;   //当前选择的item
//@property (nonatomic, strong)UIColor* backgroundColor;      //背景颜色
//@property (nonatomic, assign)UIEdgeInsets contentInset;     //本身的间距
//@property (nonatomic, assign)BOOL pagingEnabled;            //是否开启分页模式

//设置下划线显示位置

-(void)scrollToIndex:(CGFloat) floatIndex anim:(BOOL) anim;
  
@end
