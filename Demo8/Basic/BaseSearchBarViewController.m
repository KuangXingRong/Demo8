//
//  BaseSearchBarViewController.m
//  Demo4
//
//  Created by apple on 2018/7/7.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "BaseSearchBarViewController.h"
#import "SearchVIew.h"

@interface BaseSearchBarViewController ()<UINavigationControllerDelegate>


@end

@implementation BaseSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK(weakSelf, self)
    
    self.view.backgroundColor = UIColor.whiteColor;

    UIView *backView = [self.view addViewWithsize:CGSizeMake(SCREEN_WIDTH, kStatusBarHeight + 45)];
    backView.backgroundColor = MAINCOLOR;


    self.searchBarLeft = [backView addImg:Frame(15, kStatusBarHeight + 5, 30, 30) image:WhiteImage(1, 1)];

    self.searchBarRight = [backView addImg:Frame(SCREEN_WIDTH - 30 - 15, kStatusBarHeight + 5, 25, 25)  image:WhiteImage(25, 25)];

    self.searchBar = [[UISearchBar alloc]initWithFrame:Frame(_searchBarLeft.right + 5, kStatusBarHeight + 5, self.searchBarRight.left - 15 - _searchBarLeft.right , 30)];
    [self.searchBar setBackgroundColor:[UIColor whiteColor]];
    [self.searchBar.eaTextField setFont:FONT(13)];
    [self.searchBar.eaTextField setUserInteractionEnabled:NO];
    [self.searchBar setPlaceholder:@"搜索平台内容"];
    [self.searchBar.eaTextField doBorderWidth:0 color:0 cornerRadius:30 / 2];
    [self.searchBar setSearchIconSpace:15];

    [backView addSubview:self.searchBar];
    [self.searchBar addClick:^(id view) {
        SearchVIew *searchView = [[SearchVIew alloc] initWithFrame:Frame(0, kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        searchView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.98];
        __weak __typeof(&*searchView)weakSearchView = searchView;
        [searchView.btnRight addClick:^(id view) {
            [weakSearchView removeFromSuperview];
        }];
        searchView.arrayData = @[@"我阿里",@"藕粉"];
        [weakSelf.view addSubview:searchView];
    }];






    self.searchBarLeft.centerY = _searchBar.centerY;
    self.searchBarRight.centerY = _searchBar.centerY;

    [self.searchBar textFieldContentCenter:YES];

    UIView *lineView = [backView addViewWithsize:CGSizeMake(SCREEN_WIDTH, 0.8)];
    lineView.backgroundColor = LINECOLOR;
    lineView.bottom = backView.height;
    
    
    
   
}

-(void)setSearchBarLeft:(UIImageView *)searchBarLeft{
    if (!searchBarLeft) {
        self.searchBar.left = 5;
        self.searchBar.width += 45;
        [self.searchBar textFieldContentCenter:YES];
        [self.searchBarLeft removeFromSuperview];
    }
    _searchBarLeft = searchBarLeft;
}

-(void)setSearchBarRight:(UIImageView *)searchBarRight{
    if (!searchBarRight) {
        self.searchBar.width += 45;
        [self.searchBar textFieldContentCenter:YES];
        [self.searchBarRight removeFromSuperview];
    }
    _searchBarRight = searchBarRight;
}
#pragma mark - 隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL hidden = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
}


@end
