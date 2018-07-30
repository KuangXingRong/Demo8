//
//  KPickerView.h
//  Demo4
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPickerView : UIPickerView

@property (nonatomic, copy)void(^didSelectCallBack)(KPickerView* pickerView, NSArray *result);

@property(nonatomic, strong) NSMutableArray *arrayData;

@property(nonatomic, assign)BOOL clickOutsideIsSelect;
@end
