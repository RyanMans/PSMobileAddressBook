//
//  UIImage+PS.h
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PS)

/**
 *  颜色画 图片
 *
 *  @param color
 *  @param size
 *
 *  @return
 */
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
@end
