//
//  UISearchBar+Common.m
//  Coding_iOS
//
//  Created by Ease on 15/4/22.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import "UISearchBar+Common.h"

@implementation UISearchBar (Common)
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.backgroundImage = UIImage.new;
    self.barTintColor = backgroundColor;
     [self setSearchFieldBackgroundImage:[UIImage imageWithColor:backgroundColor withFrame:Frame(0, 0, 30, 30)] forState:UIControlStateNormal];
}


-(void)setSearchIconSpace:(CGFloat) space{
    self.eaTextField.leftView.width += space;
    ((UIImageView*)self.eaTextField.leftView).contentMode =  UIViewContentModeScaleAspectFit;
    ((UIImageView*)self.eaTextField.leftView).clipsToBounds = YES;
}

- (UITextField *)eaTextField{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UIView *candidateView, NSDictionary *bindings) {
        return [candidateView isMemberOfClass:NSClassFromString(@"UISearchBarTextField")];
    }];
    return [self.subviews.firstObject.subviews filteredArrayUsingPredicate:predicate].lastObject;
}
-(void)textFieldContentCenter:(BOOL) center{
    if (center) {
        CGFloat filedWidth = [self.eaTextField.placeholder getWidthWithFont:self.eaTextField.font constrainedToSize:CGSizeMake(300, 60)];
        
        [self setPositionAdjustment:UIOffsetMake((self.width - filedWidth ) / 2 - self.eaTextField.leftView.width , 0) forSearchBarIcon:UISearchBarIconSearch];
    }else{
        [self setPositionAdjustment:UIOffsetMake(0 , 0) forSearchBarIcon:UISearchBarIconSearch];
    }
   
    
}

- (void)setPlaceholderColor:(UIColor *)color{
    [[self valueForKey:@"_searchField"] setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}
- (void)setSearchIcon:(UIImage *)image{
    [self setImage:image forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.showsSearchResultsButton = YES;
}

- (void)setRightBtnIcon:(UIImage *)image{
    [self setImage:image forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    self.showsBookmarkButton = YES;
}
@end
