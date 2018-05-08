//
//  NSString+XK.h
//  XKMobileAddressBook
//
//  Created by Allen、 LAS on 2018/5/8.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XK)

- (NSString *)onlyNumbers;


/**
 *  返回中文拼音
 *
 *  @param isAs 是否返回拼音缩写
 *
 *  @return str
 */
- (NSString *)toPinyinEx:(BOOL)isAs;

@end
