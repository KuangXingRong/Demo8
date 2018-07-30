//
//  KCarousel.m
//  Dome
//
//  Created by apple on 2018/6/9.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KCarousel.h"

@interface KCarousel()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, assign) BOOL isDrag;

@end


@implementation KCarousel 

#pragma mark - init
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setKCarouselDefaultProperty];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setKCarouselDefaultProperty];
    }
    
    return self;
}

-(void)setKCarouselDefaultProperty{
    self.itemSpacing = 0; 
    [self registerClass:[KCarouselCell class] forCellWithReuseIdentifier:@"KCarouselCell"];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    
    self.isDrag = NO;
}

-(void)setCarouselDelegate:(id<KCarouselDelegate>)carouselDelegate{
    _carouselDelegate = carouselDelegate;
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.carouselDelegate respondsToSelector:@selector(numberOfItemsInCarousel:)])
    {
        return [self.carouselDelegate numberOfItemsInCarousel:self];
//        [self.carouselDelegate performSelector:@selector(numberOfItemsInCarousel:) withObject:self];
    }
    return _arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KCarouselCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KCarouselCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.whiteColor;
    [self.carouselDelegate carousel:self viewForItemAtIndex:indexPath.item reusingView:cell object:self.arrayData[indexPath.item % self.arrayData.count]];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.carouselDelegate respondsToSelector:@selector(carousel:sizeForItemAtIndex:)]) {
        self.itemSize = [self.carouselDelegate carousel:self sizeForItemAtIndex:indexPath.item];
    }
    return self.itemSize;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.carouselDelegate respondsToSelector:@selector(carousel:clickAtIndex:)])
    {
        [self.carouselDelegate carousel:self clickAtIndex:indexPath.item];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDrag = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isDrag = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    
    if (self.isDrag && [self.carouselDelegate respondsToSelector:@selector(carouselDraging:floatIndex:)])
    {
        [self.carouselDelegate carouselDraging:self floatIndex:scrollView.contentOffset.x / (self.itemSize.width + self.itemSpacing)];
    }
    
    if ([self.carouselDelegate respondsToSelector:@selector(carouselDidScroll:floatIndex:)])
    {
        [self.carouselDelegate carouselDidScroll:self floatIndex:scrollView.contentOffset.x / (self.itemSize.width + self.itemSpacing)];
    }
}



-(void)setArrayData:(NSArray *)arrayData{
    _arrayData = arrayData;
    
    UICollectionViewLayout* layout = self.collectionViewLayout;
    if ([layout isKindOfClass:UICollectionViewFlowLayout.class] ) {
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)layout;
        flowLayout.minimumLineSpacing = self.itemSpacing;
        flowLayout.minimumInteritemSpacing = self.itemSpacing;
    }
}


-(id)itemViewWithIndex:(NSInteger) index tag:(NSInteger) tag{
    UIView* view = [[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]] viewWithTag:tag];
    if (!view) {
        [self layoutIfNeeded];
        [[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]] viewWithTag:tag];
         return [[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]] viewWithTag:tag];
    }
    return view;
}


-(void)scrollToIndex:(NSInteger) index anim:(BOOL) anim{
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:anim];
}


@end




@implementation KCarouselCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView removeFromSuperview];
    }
    return self;
}
@end

