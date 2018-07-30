//
//  KPickerView.m
//  Demo4
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 kxr. All rights reserved.
//

#import "KPickerView.h"

@interface KPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) NSMutableArray *result;
@end

@implementation KPickerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}
-(void)setArrayData:(NSMutableArray *)arrayData{
    _arrayData = arrayData;
    
    self.result = [NSMutableArray arrayWithCapacity:self.numberOfComponents];

    for (int i = 0; i < self.numberOfComponents; i ++) {
        [self.result addObject:@""];
        NSInteger rowNum = [self pickerView:self numberOfRowsInComponent:i];
        NSInteger row = rowNum <= 5 ? rowNum / 2 : 2;
        
        if ([_arrayData[0] isKindOfClass:NSString.class] && _arrayData.count > row) {
            _result[i] = _arrayData[row];
            [self selectRow:row inComponent:i animated:NO];
            
        }else if ([_arrayData[i] isKindOfClass:NSArray.class] && ((NSArray *)_arrayData[i]).count > row) {
            _result[i] = _arrayData[i][row];
            [self selectRow:row inComponent:i animated:NO];
        }
    }
    
    
    if (self.didSelectCallBack) {
        self.didSelectCallBack(self, _result);
    }
    
}

//列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    if (_arrayData.count == 0) {return 0;}
    
    
    if ([_arrayData[0] isKindOfClass:NSString.class]) {
        return 1;
    }else if ([_arrayData[0] isKindOfClass:NSArray.class]) {
        return _arrayData.count;
    }else if ([_arrayData[0] isKindOfClass:NSDictionary.class]) {
        return _arrayData.count;
    }
    
    
    return 0;
}

//行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_arrayData.count == 0 || _arrayData.count <= component) {return 0;}
    
    if ([_arrayData[0] isKindOfClass:NSString.class]) {
        return _arrayData.count;
    }else if ([_arrayData[component] isKindOfClass:NSArray.class]) {
        return ((NSArray*)_arrayData[component]).count;
    }
    
    return 0;
}

//宽
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (_arrayData.count == 0) {return 0;}
    return self.width / [self numberOfComponentsInPickerView:self];
}

//高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    if (_arrayData.count == 0) {return 0;}
    return self.height / 5 ;
}

//文本
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:Frame(0, 0, [self pickerView:self widthForComponent:component], [self pickerView:self rowHeightForComponent:component])];
    label.font = FONT(15);
    label.textColor = UIColor.blackColor;
    label.textAlignment = NSTextAlignmentCenter;
    if ([_arrayData[0] isKindOfClass:NSString.class]) {
        label.text = _arrayData[row];
    }else if ([_arrayData[component] isKindOfClass:NSArray.class]) {
        label.text = _arrayData[component][row];
    }
    return label;
}


//选中事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([_arrayData[0] isKindOfClass:NSString.class]) {
        _result[component] = _arrayData[row];
    }else if ([_arrayData[component] isKindOfClass:NSArray.class]) {
        _result[component] = _arrayData[component][row];
    }
    
    if (self.didSelectCallBack) {
        self.didSelectCallBack(self, _result);
    }

}



@end
