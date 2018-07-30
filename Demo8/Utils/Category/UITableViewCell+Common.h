//
//  UITableViewCell+Common.h
//  Salesman
//
//  Created by 邝新荣 on 2018/4/21.
//  Copyright © 2018年 莘达科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Common.h"


@interface UITableViewCell(Category)
 

-(void)showCellLine:(NSIndexPath*) indexPath tableView:(UITableView*) tableView leftSpce:(CGFloat) leftSpce rightSpce:(CGFloat) rightSpce;
-(void)showCellAndSectionLine:(NSIndexPath*)indexPath tableView:(UITableView*) tableView leftSpce:(CGFloat) leftSpce rightSpce:(CGFloat) rightSpce;

- (void)autoAdaptHeight:(UIView*) lastView bottomOffset:(CGFloat) offset;
@end
