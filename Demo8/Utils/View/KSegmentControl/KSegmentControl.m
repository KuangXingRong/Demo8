//
//  KSegmentControl.m
//  Dome
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KSegmentControl.h"
#import "KSegmentItemView.h"
#import "NSString+Common.h"
@interface KSegmentControl()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

 

@property (nonatomic, strong) UIView* lineView;


@property (nonatomic, assign)NSInteger selectedItemIndex;   //当前选择的item

@property (nonatomic, strong)KSegmentItemView* selectedItemView;   //需要选中的目标

@end


@implementation KSegmentControl
{
    NSInteger callSelectedItemIndex;
}


#pragma mark - init
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaultProperty];
        self.displayOption = DisplayOptionTitle | DisplayOptionLineView;;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setDefaultProperty];
        self.displayOption = DisplayOptionTitle | DisplayOptionLineView;
    }
    return self;
}

-(void)setDefaultProperty{
    
    //image property
    self.imgSize = CGSizeMake((SCREEN_WIDTH - 60 - 30) / 4, (SCREEN_WIDTH - 60  - 30) / 4);
    self.cornerImage = YES;
    
    //title property
    self.titleMarginTop =  0;
    self.titleFont = FONT(14);
    self.titleColor = [UIColor colorWithHexString:@"0xFF0000"];
    self.titleSelectedFont= FONT(14);
    self.titleSelectedColor = [UIColor colorWithHexString:@"0xFF0000"];
    
    //lineView property
    self.lineViewWidthAuto = YES;
    self.lineViewSize = CGSizeMake(25, 3);
    _lineViewDefaultSelectIndex = 0;
    self.lineViewPadding = UIEdgeInsetsMake(5, 0, 0, 0);
    self.lineViewColor = [UIColor grayColor];
    
    //Self property
    self.itemSpacing = 20;
    self.contentInset = UIEdgeInsetsMake(5, 15, 5, 15);
    self.pagingEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = YES;
    [self registerClass:[KSegmentItemView class] forCellWithReuseIdentifier:@"KSegmentItemView"];
    self.delegate = self;
    self.dataSource = self;
    callSelectedItemIndex = -100;
}
-(void)setLineViewDefaultSelectIndex:(NSInteger)lineViewDefaultSelectIndex{
    _lineViewDefaultSelectIndex = lineViewDefaultSelectIndex;
    
    if (self.displayOption & DisplayOptionTitle) {
        self.selectedItemView = (KSegmentItemView *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:lineViewDefaultSelectIndex inSection:0]];
        
        [self.selectedItemView.labTitle setTextColor:self.titleSelectedColor];
        [self.selectedItemView.labTitle setFont:self.titleSelectedFont];
    }
    
    
    
    
    if (self.displayOption & DisplayOptionLineView) {
        CGFloat startY = [self itemSizeAtIndex:lineViewDefaultSelectIndex].height  - self.lineViewSize.height  - self.lineViewPadding.bottom;
        
        CGSize selectedSize = [self lineViewSizeAtIndex:self.selectedItemIndex];
        self.lineView.frame = CGRectMake(0, startY, selectedSize.width, selectedSize.height);
        CGRect selectedFrame = [_selectedItemView convertRect:_selectedItemView.bounds toView:self.lineView.superview];
        self.lineView.centerX = CGRectGetMidX(selectedFrame);
        self.lineView.backgroundColor = self.lineViewColor;
    }
   
    self.selectedItemIndex = lineViewDefaultSelectIndex;
    
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrayData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    KSegmentItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KSegmentItemView" forIndexPath:indexPath];
    if(!cell.propertyInit){
        //image property
        cell.imgSize = self.imgSize;  //图片尺寸
        cell.cornerImage = self.cornerImage;  //是否是圆图
        
        //title property
        cell.titleMarginTop = self.titleMarginTop;  //标题尺寸
        cell.titleFont = self.titleFont;    //标题字体
        cell.titleColor = self.titleColor;   //标题颜色
        if ( self.displayOption & DisplayOptionImage){ [cell imgIcon];}
        [cell.labTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            CGSize size1 = [@"中" getSizeWithFont:self.titleSelectedFont constrainedToSize:CGSizeMake(1000, CGFLOAT_MAX)];
            CGSize size2 =  [@"中" getSizeWithFont:self.titleFont constrainedToSize:CGSizeMake(1000, CGFLOAT_MAX)];
            make.height.mas_equalTo(MAX(size1.height, size2.height));
        }];
        cell.propertyInit = NO;
    }
    
    
    if ( self.displayOption & DisplayOptionImage){
        [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:_arrayData[indexPath.item][@"imgURL"]]];
        cell.imgIcon.backgroundColor = UIColor.redColor;
    }
    
    
    if ( self.displayOption & DisplayOptionTitle){
        
        [cell.labTitle setTextColor:self.titleColor];
        [cell.labTitle setFont:self.titleFont];
        [cell.labTitle setText:_arrayData[indexPath.item][@"title"]];
    }
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self itemSizeAtIndex:indexPath.item ];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self scrollToIndex:indexPath.item anim:YES];
}


#pragma mark - LineView
-(void)scrollToIndex:(CGFloat) floatIndex anim:(BOOL) anim {
    
    
    if (anim ) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
   
    
    
    NSInteger index = MAX(0, (int)floorf(floatIndex));
    
    if (((NSInteger)(floatIndex * 1000000)) % 1000000 > 0 && index == self.selectedItemIndex) {
        index++ ;
    }
    if (index >= [self numberOfItemsInSection:0]) {
        index = [self numberOfItemsInSection:0] - 1;
    }
 
//    NSLog(@"floatIndex:%f   index:%ld    selectedItemIndex%ld", floatIndex, index, self.selectedItemIndex);
    
    
    KSegmentItemView* targetSelectView = (KSegmentItemView*)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    
    if (self.superview ) {
        if (!targetSelectView && [self numberOfItemsInSection:0] > index && index >= 0) {
            [UIView animateWithDuration:0.4 animations:^{
                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
            }];
            
            targetSelectView = (KSegmentItemView*)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        }else{
            CGRect targetFrame2 = [targetSelectView convertRect:targetSelectView.bounds toView:self.superview];
            if (CGRectGetMinX(targetFrame2) < self.contentInset.left || CGRectGetMaxX(targetFrame2) > CGRectGetWidth(self.bounds) - self. contentInset.right) {
                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:YES];
            }
        }
        
    }
    
    if (((NSInteger)(floatIndex * 1000000)) % 1000000 == 0 || ABS(floatIndex - self.selectedItemIndex) > 1) {
        
        [self.selectedItemView.labTitle setTextColor:self.titleColor];
        [self.selectedItemView.labTitle setFont:self.titleFont];
        self.selectedItemView = targetSelectView;
        
        
        if (((NSInteger)(floatIndex * 1000000)) % 1000000 == 0) {
            if (self.itemSelectedBlock && self.selectedItemIndex != index) {
                self.itemSelectedBlock(index);
            }
        }
        self.selectedItemIndex = index;
        
        if (self.displayOption & DisplayOptionTitle) {
            [self.selectedItemView.labTitle setTextColor:self.titleSelectedColor];
            [self.selectedItemView.labTitle setFont:self.titleSelectedFont];
        }
        
        
        
    }
    
    
    
    if (!(self.displayOption & DisplayOptionLineView)) {
        if (anim) {
            [UIView commitAnimations];
        }
        return;
    }
    
    CGRect targetFrame = [targetSelectView convertRect:targetSelectView.bounds toView:self.lineView.superview];
  
    
    CGFloat targetCenterX = CGRectGetMidX(targetFrame);
    
    
    
    CGFloat sacle = 0;
    if ((int)floorf(floatIndex) < self.selectedItemIndex) {
        sacle = 1 - (floatIndex - (int)floorf(floatIndex));
    }else{
        sacle = floatIndex - (int)floorf(floatIndex);
    }
    if (sacle == 0) {
        sacle = 1;
    }
    
    CGFloat startY = [self itemSizeAtIndex:index].height  - self.lineViewSize.height  - self.lineViewPadding.bottom;
    
    CGSize selectedSize = [self lineViewSizeAtIndex:self.selectedItemIndex];
    CGSize targeetSize = [self lineViewSizeAtIndex:index];
    
    CGFloat currentWidth = sacle * (targeetSize.width - selectedSize.width) + selectedSize.width;
    _lineView.frame = CGRectMake(0, startY, currentWidth - self.lineViewPadding.left - self.lineViewPadding.right, targeetSize.height);
   
    
    CGRect selectedFrame = [self.selectedItemView convertRect:self.selectedItemView.bounds toView:self.lineView.superview];
    CGFloat selectedCenterX = CGRectGetMidX(selectedFrame);
    CGFloat currentCenterX = sacle * ( targetCenterX - selectedCenterX ) + selectedCenterX ;
    
    _lineView.centerX = currentCenterX;
    
    
    if (anim) {
        [UIView commitAnimations];
    }
    
}

-(UIView *)lineView{
    if (_lineView == nil && (self.displayOption & DisplayOptionLineView)) {
        _lineView = UIView.new;
        [self addSubview:_lineView];
        _lineView.backgroundColor = self.lineViewColor;
    }
    return _lineView;
}


#pragma mark - setData and refreshUI
-(void)setArrayData:(NSArray<NSDictionary*>*)arrayData{
    _arrayData = arrayData;
     self.size = CGSizeMake([self width], [self height]);
    
    if ([self.collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class] ) {
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
        flowLayout.minimumLineSpacing = self.itemSpacing;
        flowLayout.minimumInteritemSpacing = self.itemSpacing;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    if (arrayData.count > 0) {
        [self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
   
}

-(void)reloadData{
    [super reloadData];
    if (self.arrayData.count > 0) {
        [self layoutIfNeeded];
        [self setLineViewDefaultSelectIndex:_lineViewDefaultSelectIndex];
    }
    
}



#pragma mark - Size
-(CGSize)titleSizeAtIndex:(NSInteger) index{
    NSString *string = _arrayData[index][@"title"];
    CGFloat width = 0, height = 0;
    if (string) {
        CGSize size1 = [string getSizeWithFont:self.titleSelectedFont constrainedToSize:CGSizeMake(1000, CGFLOAT_MAX)];
        CGSize size2 =  [string getSizeWithFont:self.titleFont constrainedToSize:CGSizeMake(1000, CGFLOAT_MAX)];
        width = MAX(size1.width, size2.width);
        width = MAX(width, self.titleSize.width);
        
        height = MAX(size1.height, size2.height);
        height = MAX(height, self.titleSize.height);
    }
    return CGSizeMake(width, height);
}

-(CGSize)lineViewSizeAtIndex:(NSInteger) index{
    CGFloat width = 0, height = 0;
    
    if (self.lineViewWidthAuto) {
        NSString *string = _arrayData[index][@"title"];
        UIFont* font = index == self.selectedItemIndex ? self.titleSelectedFont : self.titleFont;
        CGSize size1 = [string getSizeWithFont:font constrainedToSize:CGSizeMake(1000, CGFLOAT_MAX)];
        width = size1.width;
    }else{
        width = self.lineViewSize.width;
    }
    height = self.lineViewSize.height;
    
    return CGSizeMake(width, height);
}

-(CGSize) itemSizeAtIndex:(NSInteger) index{
    CGFloat width = 0, height = 0;
     if (self.displayOption & DisplayOptionLineView){
         height = [self lineViewSizeAtIndex:index].height + self.lineViewPadding.top + self.lineViewPadding.bottom;
    }
    if (self.displayOption & DisplayOptionImage){
        height += self.imgSize.height;
        width =  self.imgSize.width;
    }
    
    if (self.displayOption & DisplayOptionTitle){
        CGSize titleSize = [self titleSizeAtIndex:index];
        height += titleSize.height + self.titleMarginTop ;
        width = MAX(titleSize.width, width);
    }
    
    return CGSizeMake(width, height);
}

-(CGFloat) height{
    return [self itemSizeAtIndex:0].height + self.contentInset.top + self.contentInset.bottom;
}
-(CGFloat) width{
    CGFloat width = 0;
    for (int i = 0; i < _arrayData.count; i++) {
        width += [self itemSizeAtIndex:i].width + self.itemSpacing;
    }
    width += self.contentInset.left + self.contentInset.right - self.itemSpacing ;
    
    return width;
}

//自适应高度
-(CGSize)intrinsicContentSize{
    return CGSizeMake([self width], [self height]);
}



@end
