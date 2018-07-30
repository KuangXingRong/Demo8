//
//  KCollectionViewFlowLayout.h
//  Demo3
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KCollectionViewFlowLayoutDelegate;

@interface KCollectionViewFlowLayout : UICollectionViewFlowLayout

@property(nonatomic, weak) id<KCollectionViewFlowLayoutDelegate> delegate;

@end


@protocol KCollectionViewFlowLayoutDelegate <UIScrollViewDelegate>

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(KCollectionViewFlowLayout*)collectionViewLayout minimumInteritemSpacingForIndexPath:(NSIndexPath *)indexPath;

@end
