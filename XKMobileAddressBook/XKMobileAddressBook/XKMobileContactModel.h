//
//  XKMobileContactModel.h
//  XKMobileAddressBook
//
//  Created by Allen、 LAS on 2018/5/8.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKMobileContactModel : NSObject

// 用户名
@property(nonatomic,copy)NSString * name;

//手机号码
@property (nonatomic, copy) NSString * mobile;

//邮箱地址
@property (nonatomic, copy) NSString * email;

//通讯录插入记录的唯一id
@property (nonatomic, copy) NSString * recordID;

//手机号码集合 - 一人多号
@property (nonatomic, strong) NSArray * mobileNumberArrs;

//邮箱集合
@property (nonatomic, strong) NSArray * emailArrs ;

//名字纯拼音
@property (nonatomic,copy,readonly)NSString * nameFullPin;

//名字首字母拼音
@property (nonatomic,copy,readonly)NSString * nameFirstLetter;


/**
 *  字典转模型
 *
 *  @param dict
 *
 *  @return
 */
+ (instancetype)modelWithDictionary:(NSDictionary*)dict;

/**
 *  字典数组转化成模型数组
 *
 *  @param arrays
 *
 *  @return
 */
+ (NSArray*)modelWithKeyValuesArrays:(NSArray*)arrays;

/**
 *  模型转字典
 *
 *  @return
 */
- (NSDictionary*)dictionary;
@end
