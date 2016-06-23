//
//  PSMobileBookUtil.h
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSMobileContactModel.h"
@interface PSMobileBookUtil : NSObject
+ (NSMutableArray *)getAllMobileContacts;

// 主线程
void runBlockWithMain(dispatch_block_t block);
// 异步线程
void runBlockWithAsync(dispatch_block_t block);
//先异步 后同步
void runBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock);
@end
