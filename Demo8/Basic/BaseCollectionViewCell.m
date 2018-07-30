//
//  BaseCollectionViewCell.m
//  Demo3
//
//  Created by apple on 2018/6/24.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addObserver:self forKeyPath:@"reuseIdentifier" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self removeObserver:self forKeyPath:@"reuseIdentifier"];
    [self initWithReuseIdentifier:self.reuseIdentifier];
}


-(void)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
}
@end
