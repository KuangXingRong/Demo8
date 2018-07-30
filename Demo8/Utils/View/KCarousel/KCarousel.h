//
//  KCarousel.h
//  Dome
//
//  Created by apple on 2018/6/9.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KCarouselDelegate;

@interface KCarousel : UICollectionView

@property (nonatomic, weak ) id<KCarouselDelegate> carouselDelegate;

@property (nonatomic, strong) NSArray* arrayData;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGSize itemSize;

-(id)itemViewWithIndex:(NSInteger) index tag:(NSInteger) tag;

-(void)scrollToIndex:(NSInteger) index anim:(BOOL) anim;

@end


@protocol KCarouselDelegate <NSObject>


- (void)carousel:(KCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view  object:(id) itemData;

@optional

- (void)carousel:(KCarousel *)carousel clickAtIndex:(NSInteger)index;

- (CGSize)carousel:(KCarousel *)carousel sizeForItemAtIndex:(NSInteger)index;

- (void)carouselDidScroll:(KCarousel *)carousel floatIndex:(CGFloat) floatIndex;

- (void)carouselDraging:(KCarousel *)carousel floatIndex:(CGFloat) floatIndex;

-(NSInteger)numberOfItemsInCarousel:(KCarousel *)carousel;


@end


@interface KCarouselCell : UICollectionViewCell

@end


