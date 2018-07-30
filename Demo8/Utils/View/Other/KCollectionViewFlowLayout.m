//
//  KCollectionViewFlowLayout.m
//  Demo3
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KCollectionViewFlowLayout.h"

@implementation KCollectionViewFlowLayout

-(void)prepareLayout{
    [super prepareLayout];
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray<UICollectionViewLayoutAttributes*> *attrs = [super layoutAttributesForElementsInRect:rect];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        
        for (int i = 0; i < attrs.count; i++) {
            if ([attrs[i].representedElementKind isEqualToString:@"UICollectionElementKindSectionHeader"] ||
                [attrs[i].representedElementKind isEqualToString:@"UICollectionElementKindSectionFooter"]) {
                continue;
            }
            
            CGFloat spacing = self.minimumInteritemSpacing;
            SEL sector = @selector(collectionView:layout:minimumInteritemSpacingForIndexPath:);
            if ([self.delegate respondsToSelector:sector]) {
                spacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForIndexPath:attrs[i].indexPath];
            }
            
            
            if (attrs[i].frame.origin.x == 0) {
                attrs[i].frame = CGRectMake(spacing, attrs[i].frame.origin.y, attrs[i].frame.size.width, attrs[i].frame.size.height);
            }else if(i > 0){
                attrs[i].frame = CGRectMake(attrs[i -1].frame.origin.x + attrs[i -1].frame.size.width + spacing, attrs[i].frame.origin.y , attrs[i].frame.size.width, attrs[i].frame.size.height);
            }
            
            
        }
        
    }
    
    
    return attrs;
}


@end
