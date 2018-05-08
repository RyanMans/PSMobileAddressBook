//
//  XKMobileContactModel.m
//  XKMobileAddressBook
//
//  Created by Allen、 LAS on 2018/5/8.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import "XKMobileContactModel.h"
#import "NSString+XK.h"
#import "YYModel.h"

@interface XKMobileContactModel()
@property (nonatomic,copy)NSString * nameFullPin;
@property (nonatomic,copy)NSString * nameFirstLetter;
@end

@implementation XKMobileContactModel

+ (instancetype)modelWithDictionary:(NSDictionary*)dict
{
    if (dict.count == 0 || !dict)  return [XKMobileContactModel new];;
    
    return [self yy_modelWithDictionary:dict];
}

- (NSDictionary*)dictionary{
    return (NSDictionary*)[self yy_modelToJSONObject];
}

+ (NSArray*)modelWithKeyValuesArrays:(NSArray*)arrays{
    
    if (arrays.count == 0 || !arrays)  return @[];
    
    return [NSArray yy_modelArrayWithClass:self json:arrays];
}


//名字全拼音
- (NSString*)nameFullPin{
    
    if (_nameFullPin.length) return _nameFullPin;
    
    _nameFullPin =  [self.name toPinyinEx:NO];
    
    return _nameFullPin;
}

//首字母拼音
- (NSString*)nameFirstLetter{
    
    if (_nameFirstLetter.length) return _nameFirstLetter;

     _nameFirstLetter =  [self.name toPinyinEx:YES];
    
    if (_nameFirstLetter.length == 0) _nameFirstLetter = @"#";
    //不在26位字母之内
    else if (('A' <= [_nameFirstLetter characterAtIndex:0] && [_nameFirstLetter characterAtIndex:0] <= 'Z') == NO){
        _nameFirstLetter = @"#";
    }
    return _nameFirstLetter;
}
@end
