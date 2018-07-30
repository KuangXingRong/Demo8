//
//  CollectionViewCell+Common.m
//  Demo3
//
//  Created by apple on 2018/6/24.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "CollectionViewCell+Common.h"

@implementation UICollectionViewCell(Common)

- (void)autoAdaptSize:(CGSize)size{
    if (CGSizeEqualToSize(size, self.contentView.size)) {
        return;
    }
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(0);
        make.right.mas_offset(0).priorityHigh();
        make.bottom.mas_offset(0).priorityHigh();
        make.size.mas_equalTo(size);
    }];
}



@end
