//
//  SearchVIew.m
//  Demo6
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "SearchVIew.h"
#import "UISearchBar+Common.h"
#import "KCollectionViewFlowLayout.h"

@interface SearchVIew()<UISearchBarDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;


@end



@implementation SearchVIew

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:Frame(0, 0, SCREEN_WIDTH - X(60), 30)];
        [searchBar setBackgroundColor:WHITECOLOR];
        UITextField *textField = searchBar.eaTextField;
        [textField doBorderWidth:1 color:LINECOLOR cornerRadius:0];
        textField.font = FONT(13);
        textField.placeholder = @"搜索商品";
        textField.returnKeyType = UIReturnKeySearch;
        [textField becomeFirstResponder];
        searchBar.delegate = self;
        
        [searchBar setSearchIconSpace:15];
        [searchBar setRightBtnIcon:RedImage(16, 22)];
        [self addSubview:searchBar];
        searchBar.left = X(10);
        searchBar.centerY = 44 / 2;
        
        self.btnRight = [self addBtn:@"取消" fontSize:14 color:0x999999 size:CGSizeMake(X(65), 30)];
        _btnRight.right = SCREEN_WIDTH;
        _btnRight.centerY = searchBar.centerY;
        
        UIView *lineView = [self addViewWithBGColor:0xDDDDDD size:CGSizeMake(SCREEN_WIDTH, 1)];
        lineView.bottom = _btnRight.bottom + searchBar.top ;
        
        
        
        UICollectionViewFlowLayout *layout = [[KCollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.estimatedItemSize = CGSizeMake(1, 1);
        layout.itemSize = CGSizeMake(22, 22);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
       
         [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
         [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
  
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        self.collectionView.frame = Frame(0, lineView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - lineView.bottom - kBottomSafeHeight);

    }
    return self;
}


-(void)setArrayData:(NSArray<NSString *> *)arrayData{
    _arrayData = arrayData;
    [self.collectionView reloadData];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarSearchButtonClicked");
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrayData.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIButton *btn = [cell viewWithTag:100];
    
    NSString *title = _arrayData[indexPath.item];
    if (!btn) {
        btn = [cell addBtn:title fontSize:14 color:0x333333 size:CGSizeZero];
        btn.backgroundColor = WHITECOLOR;
        btn.tag = 100;
    }
    CGSize textSize = [title getSizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH, 30)];
    btn.size = CGSizeMake(textSize.width + 20, textSize.height + 10);
    btn.left = 15;
    [btn doBorderWidth:0 color:0 cornerRadius:btn.size.height / 2];
    [cell autoAdaptSize:CGSizeMake(btn.right, btn.bottom)];
    
    return cell;
    
}

//返回cell尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     return CGSizeMake(22, 22);
}

//返回头部视图的尺寸，如果想要使用头视图，则必须实现该方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 60);
}

//返回尾部视图的尺寸，如果想要使用头视图，则必须实现该方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 60);
}



-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
        
        if (headerView.subviews.count == 0) {
            UILabel *labTitle =  [headerView addLab:@"最近搜索" fontSize:15 color:0x999999 maxWidth:200];
            labTitle.left = 15;
            labTitle.centerY = 30;
        }
        
        
        
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        
        if (footerView.subviews.count == 0) {
            UILabel *labClear = [footerView addLab:@"清空历史" fontSize:15 color:0x999999 maxWidth:200];
            [labClear addClick:^(id view) {
                NSLog(@"清空历史");
            }];
            labClear.size = CGSizeMake(labClear.width + 30, labClear.height + 10);
            labClear.centerX = SCREEN_WIDTH /2;
            labClear.bottom = 80;
            labClear.textAlignment = NSTextAlignmentCenter;
            [labClear doBorderWidth:1 color:UIColor.brownColor cornerRadius:5];
            
        }
        
        
        
        return footerView;
    }
    
}
@end
