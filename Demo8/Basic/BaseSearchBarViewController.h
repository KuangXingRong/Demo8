//
//  BaseSearchBarViewController.h
//  Demo4
//
//  Created by apple on 2018/7/7.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "BaseViewController.h"
#import "UISearchBar+Common.h"


@interface BaseSearchBarViewController : BaseViewController

@property(nonatomic, strong) UIImageView *searchBarLeft,*searchBarRight;
@property(nonatomic, strong) UISearchBar * searchBar;

@end
