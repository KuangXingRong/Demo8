//
//  UITableViewCell+Common.m
//  Salesman
//
//  Created by 邝新荣 on 2018/4/21.
//  Copyright © 2018年 莘达科技. All rights reserved.
//

#import "UITableViewCell+Common.h"

@implementation UITableViewCell(Category)
 


-(void)showCellLine:(NSIndexPath*) indexPath tableView:(UITableView*) tableView leftSpce:(CGFloat) leftSpce rightSpce:(CGFloat) rightSpce{
    if (indexPath.row != [tableView numberOfRowsInSection:indexPath.section]-1){
        //中间的cell。只加下短线
        [self showLine:DisplayPositionBottom leftSpce:leftSpce rightSpce:rightSpce];
    }else{
        [self showLine:DisplayPositionNone leftSpce:leftSpce rightSpce:rightSpce];
    }
}
-(void)showCellAndSectionLine:(NSIndexPath*)indexPath tableView:(UITableView*) tableView leftSpce:(CGFloat) leftSpce rightSpce:(CGFloat) rightSpce{
    if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        //只有一个cell。加上长线&下长线
        [self showLine:DisplayPositionBottom|DisplayPositionTop leftSpce:0 rightSpce:0];
        
    } else if (indexPath.row == 0) {
        //第一个cell。加上长线&下短线
        [self showLine:DisplayPositionTop|DisplayPositionNOHidden leftSpce:0 rightSpce:0];
        [self showLine:DisplayPositionBottom|DisplayPositionNOHidden leftSpce:leftSpce rightSpce:rightSpce];
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        //最后一个cell。加下长线
        [self showLine:DisplayPositionBottom leftSpce:0 rightSpce:0];
        
    } else {
        //中间的cell。只加下短线
        [self showLine:DisplayPositionBottom leftSpce:leftSpce rightSpce:rightSpce];
    }
}

- (void)autoAdaptHeight:(UIView*) lastView bottomOffset:(CGFloat) offset{
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(lastView.top).priorityHigh();
        make.left.mas_offset(lastView.left);
        make.size.mas_equalTo(lastView.size).priorityHigh();
        make.bottom.mas_offset(-offset).priorityHigh();
    }];
    lastView.superview.size = CGSizeMake(SCREEN_WIDTH, lastView.bottom + offset);
}


@end
