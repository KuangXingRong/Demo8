//
//  UIImage+Common.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-4.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface UIImage (Common)

//创建颜色图片
+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

//创建二维码图片
+(UIImage*)codeImageWithString:(NSString*) string;

//图片缩放尺寸
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage*)scaledToMaxSize:(CGSize )size;

//图片压缩到固定大小
- (NSData *)dataSmallerThan:(NSUInteger)dataLength;

//圆角图片
- (UIImage *)circleImage;
@end
