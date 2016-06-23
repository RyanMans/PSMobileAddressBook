//
//  PSMobileContactModel.m
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSMobileContactModel.h"
@interface PSMobileContactModel ()
@property (nonatomic, strong) NSString *fullPY;
@property (nonatomic, strong) NSString *firstPY;
@end
@implementation PSMobileContactModel



- (NSString *)fullPY
{
    if (_fullPY.length) return _fullPY;
    _fullPY = [self.name toPinyinEx:NO];
    return _fullPY;
}

- (NSString *)firstPY
{
    if (_firstPY.length) return _firstPY;
    _firstPY = [self.name toPinyinEx:YES];
    if (0 == _firstPY.length)
    {
        _firstPY = @"#";
        return @"#";
    }
    if (NO == ('A' <= [_firstPY characterAtIndex:0] && [_firstPY characterAtIndex:0] <= 'Z'))
    {
        _firstPY = @"#";
    }
    return _firstPY;
}


@end
