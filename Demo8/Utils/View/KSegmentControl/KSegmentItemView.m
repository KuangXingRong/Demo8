//
//  KSegmentItemView.m
//  Dome
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KSegmentItemView.h"
#import "KSegmentControl.h"

@implementation KSegmentItemView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView removeFromSuperview];
    }
    return self;
}

-(UIImageView *)imgIcon{
    if(!_imgIcon){
        _imgIcon = [[UIImageView alloc] init];
        if( self.cornerImage){
            [_imgIcon doBorderWidth:0 color:UIColor.clearColor cornerRadius:self.imgSize.width /2];
        }
        [self addSubview:_imgIcon];
        [_imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.imgSize);
            make.top.mas_offset(0);
            make.centerX.mas_equalTo(self);
        }];
    }
    return _imgIcon;
}

-(UILabel *)labTitle{
    if(!_labTitle){
        _labTitle = [UILabel new] ;
        _labTitle.textColor = self.titleColor;
        _labTitle.font = self.titleFont;
        _labTitle.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:_labTitle];
        [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            if(self->_imgIcon){
                make.top.mas_equalTo(self.imgIcon.mas_bottom).mas_offset(self.titleMarginTop);
            }
            
            make.top.mas_equalTo(self).mas_offset(self.titleMarginTop).priorityLow();
            make.centerX.mas_equalTo(self);
//            make.height.mas_equalTo(self.titleSize.height);
        }];
        
    }
    return _labTitle;
}
 
@end
