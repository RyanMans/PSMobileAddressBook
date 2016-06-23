//
//  PSMobileContactModel.h
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSBaseModel.h"

@interface PSMobileContactModel : PSBaseModel
@property (nonatomic, copy) NSString * recordID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * email;


@property (nonatomic, strong) NSArray * mobileArr;
@property (nonatomic, strong) NSArray *emailArr;

@property (nonatomic, strong, readonly) NSString *fullPY;
@property (nonatomic, strong, readonly) NSString *firstPY;
@end
