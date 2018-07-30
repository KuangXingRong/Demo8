//
//  KSlideView.m
//  Dome
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KSlideView.h"


@interface KSlideView()
 
@property(nonatomic, strong) NSTimer *myTimer;
@property(nonatomic, assign) NSInteger currentItemIndex;
@end

@implementation KSlideView

#pragma mark - init
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaultProperty];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         [self setDefaultProperty];
    }
    
    return self;
}

-(void)setDefaultProperty{
    //public property
    self.isCycle = YES;
    self.autoSlide = YES;
    self.autoSlideTime = 5.0f;
    self.currentItemIndex = 0;
    self.showPageControl = YES;
    
    //private property
    self.pagingEnabled = YES;
    self.carouselDelegate = self;
    self.backgroundColor = [UIColor whiteColor];
    self.tag = 7483252;
}

#pragma mark - init PageControll
-(SMPageControl *)pageControl{
    if (_pageControl == nil && self.showPageControl) {
        _pageControl = [[SMPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        //_pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xFFFFFF"] withFrame:CGRectMake(0, 0, 8, 8)].circleImage;
        _pageControl.currentPageIndicatorImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xAAAAAA"] withFrame:CGRectMake(0, 0, 8, 8)].circleImage;
       
        
    }
    return _pageControl;
}
    
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self.superview addSubview:self.pageControl];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.pageControl.size = CGSizeMake(self.width, 40);
    self.pageControl.bottom = self.bottom;
    self.pageControl.left = self.left;
}

#pragma mark - KCarouselwDelegate


-(NSInteger)numberOfItemsInCarousel:(KCarousel *)carousel{
    if (!self.isCycle) {
        return self.arrayData.count;
    }
    return 100000;
}

-(CGSize)carousel:(KCarousel *)carousel sizeForItemAtIndex:(NSInteger)index{
   
    return self.bounds.size;
}

-(void)carousel:(KCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view object:(id)itemData{
    
    
    UIImageView *imgIcon = [view viewWithTag:100];
    if (imgIcon == nil) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(carousel.bounds), CGRectGetHeight(carousel.bounds));
        imgIcon = [[UIImageView alloc] initWithFrame: frame];
        imgIcon.contentMode = UIViewContentModeScaleAspectFill;
        imgIcon.clipsToBounds = YES;
        imgIcon.tag = 100;
        [view addSubview:imgIcon];
    }
    
    [imgIcon sd_setImageWithURL:[NSURL URLWithString:itemData] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        imgIcon.image = image;
    }];
    
    if ([self.slideViewDelegate respondsToSelector:@selector(slideView: viewForItemAtIndex:reusingView:object:)]){
        [self.slideViewDelegate slideView:self viewForItemAtIndex:index reusingView:view object:itemData];
    }
}
- (void)carousel:(__unused KCarousel *)carousel clickAtIndex:(NSInteger)index{
    if (self.itemClickBlock) {
        self.itemClickBlock(index);
    }
}

- (void)carouselDidScroll:(KCarousel *)carousel floatIndex:(CGFloat) floatIndex{
    [self stopTimer];
    if (((NSInteger)(floatIndex * 1000000)) % 1000000 == 0) {
        self.currentItemIndex = floatIndex;
//        NSLog(@"%ld",_currentItemIndex);
        [self.pageControl setCurrentPage:self.currentItemIndex % self.arrayData.count];
        [self addTimer];
        
    }
    if (self.scrollOffsetBlock) {
        self.scrollOffsetBlock(floatIndex);
    }
}

#pragma mark - NSTimer
-(void)addTimer{
    if (self.autoSlide) {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoSlideTime target:self selector:@selector(timerCallback) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
    }
}


-(void)stopTimer{
    [self.myTimer invalidate];
    self.myTimer = nil;
}

-(void)timerCallback{
    
    self.currentItemIndex ++;
//    NSLog(@"%ld",_currentItemIndex);

    if (self.currentItemIndex >= [self numberOfItemsInCarousel:self]) {
        self.currentItemIndex = 0;
    }
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentItemIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:YES];
    }

-(void)dealloc{
    [self stopTimer];
}


#pragma mark - Public Method
-(void)setArrayData:(NSArray *)arrayData{
    [super setArrayData:arrayData];
    [self stopTimer];
    
}

-(void)reloadData{
    [super reloadData];
    
    if (self.arrayData.count > 0) {
        [self layoutIfNeeded];
        if(self.isCycle){
            self.currentItemIndex = 5000  - (5000 % self.arrayData.count);
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem: self.currentItemIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
        }else{
            [self addTimer];
        }
        [self.pageControl setNumberOfPages:self.arrayData.count];
        if (self.arrayData.count > 0) {
            [self.pageControl setCurrentPage:0];
        }
        
    }
    
    
}
@end



@implementation UIView(UIView_KSlideView)

- (KSlideView*) addKSlideView:(CGRect) frame{
    KSlideView *sv = [[KSlideView alloc] initWithFrame:frame];
    [self addSubview:sv];
    return sv;
}
@end
