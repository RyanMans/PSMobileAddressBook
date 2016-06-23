//
//  NSString+PS.h
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PS)

/**
 *  只有数字
 *
 *  @return
 */
- (NSString *)onlyNumbers;

/**
 *  返回中文拼音
 *
 *  @param isShort 是否返回拼音缩写
 *
 *  @return
 */
- (NSString *)toPinyinEx:(BOOL)isShort;
@end
